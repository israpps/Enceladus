#include "include/luaplayer.h"
#include <dirent.h>
#include <errno.h>
#include <libmc.h>
#include <loadfile.h>
#include <malloc.h>
#include <string.h>
#include <sys/fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include "include/dbgprintf.h"
#include "baexec-system_paths.h"

extern "C" {
#include "include/libsecr.h"
}

static int lua_initsecrman(lua_State *L)
{
    DPRINTF("%s: start\n", __func__);
    int argc = lua_gettop(L);
#ifndef SKIP_ERROR_HANDLING
    if (argc != 0)
        return luaL_error(L, "wrong number of arguments(%s:%d)", __FILE__, __LINE__);
#endif
    int result = SecrInit();
    lua_pushinteger(L, result);
    return 0;
}

static int lua_deinitsecrman(lua_State *L)
{
    DPRINTF("%s: start\n", __func__);
    int argc = lua_gettop(L);
#ifndef SKIP_ERROR_HANDLING
    if (argc != 0)
        return luaL_error(L, "wrong number of arguments(%s:%d)", __FILE__, __LINE__);
#endif

    SecrDeinit();
    return 0;
}

static int SignKELF(void *buffer, int size, unsigned char port, unsigned char slot)
{
    DPRINTF("%s: start\n\tbuffer_size=%d, port=%d, slot=%d\n", __func__, size, port, slot); 
    int result; //, InitSemaID, mcInitRes;

    /*	An IOP reboot would be done by the Utility Disc,
            to allow the SecrDownloadFile function of secrman_special to work on a
       DEX, even though secrman_special was meant for a CEX. A DEX was designed so
       that card authentication will not work right when a CEX SECRMAN module is
       used. This works since the memory card was authenticated by the ROM's
       SECRMAN module and SecrDownloadFile does not involve card authentication.
            However, to speed things up and to prevent more things from going
       wrong (particularly with USB support), we just reboot the IOP once at
       initialization and load all modules there. Our SECRMAN module is a custom
       version that has a check to support the DEX natively.	*/

    result = 1;
    // DEBUG_PRINTF("Entering again SecrDownloadFile %d %d
    // %x.\n",port,slot,buffer);
    if (SecrDownloadFile(2 + port, slot, buffer) == NULL) {
        DPRINTF("%s: Error signing file.\n", __func__); 
        result = -EINVAL;
    }

    return result;
}

static int lua_secrdownloadfile(lua_State *L)
{
    int argc = lua_gettop(L);
#ifndef SKIP_ERROR_HANDLING
    if ((argc != 4) && (argc != 5))
        return luaL_error(L, "wrong number of arguments");
#endif
    int port = luaL_checkinteger(L, 1);
    int slot = luaL_checkinteger(L, 2);
    const char *file_tbo = luaL_checkstring(L, 3);
    const char *dest = luaL_checkstring(L, 4);
    int flags = 0;

    if (argc == 5) {
        flags = luaL_checkinteger(L, 5);
        DPRINTF("%s: Flags are %%d=%d or %%x=%x\n", __FUNCTION__, flags, flags); 
    }

    DPRINTF("--------------------\n%s: Starting with %d argumments:\n"
            "[Port]: %d\n"
            "[Slot]: %d\n"
            "[input KELF]: %s\n"
            "[output KELF]: %s\n"
            "[flags]: %x\n",
            __func__, argc,
            port, slot, file_tbo, dest, flags); 
    void *buf;
    int result = 0;

    int fd = open(file_tbo, O_RDONLY);
    DPRINTF("%s: input fd is %d\n", __func__, fd); 
    if (fd < 0) {
        lua_pushinteger(L, -201);
        return 1;
    }
    int size = lseek(fd, 0, SEEK_END);
    DPRINTF("%s: KELF size is %d\n", __func__, size); 
    if (size < 0) {
        close(fd);
        lua_pushinteger(L, -201);
        return -EIO;
    }
    lseek(fd, 0, SEEK_SET);
    if ((buf = memalign(64, size)) != NULL) {
        if ((read(fd, buf, size)) != size) {
            close(fd);
            result = -EIO;
        } else {
            close(fd);
            if ((result = SignKELF(buf, size, port, slot)) < 0) {
                free(buf);
                DPRINTF("%s: SignKELF failed with value %d\n", __func__, result); 
            } else {
                DPRINTF("%s: SignKELF returns %d\n", __func__, result); 
                if (flags == 0) {
                    DPRINTF("flags was empty, performing normal install!\n"); 
                    int McFileFD = open(dest, O_WRONLY | O_CREAT | O_TRUNC);
                    DPRINTF("%s: [%s] fd is (%d)\n", __func__, dest, McFileFD); 
                    int written = write(McFileFD, buf, size);
                    if (written != size) {
                        result = -EIO;
                    }
                    DPRINTF("%s: written %d\n", __func__, written); 
                    close(McFileFD);
                } else {
                    DPRINTF("%s:flags was not empty, performing multiple installation\n", __func__); 
                    int x = 0, TF = 0;
                    char output[64];
                    for (x = 2; x < SYSTEM_UPDATE_COUNT; x++) // start from index 2, since 0 and 1 are kernel patches, wich require different value for file_tbo
                    {
                        TF = (1 << (x + 1));
                        DPRINTF("%s: trying with %s ", __func__, sysupdate_paths[BSM2AI(TF)]); 
                        if (flags & TF) {
                            sprintf(output, "mc%d:/%s", port, sysupdate_paths[BSM2AI(TF)]);
                            DPRINTF("\tIT IS FLAGGED\n"); 
                            int McFileFD = open(output, O_WRONLY | O_CREAT | O_TRUNC);
                            DPRINTF("%s: [%s] fd is (%d)\n", __func__, sysupdate_paths[BSM2AI(TF)], McFileFD); 
                            int written = write(McFileFD, buf, size);
                            DPRINTF("%s: written %d\n", __func__, written); 
                            close(McFileFD);
                            if (written != size) {
                                result = -EIO;
                                break;
                            }
                        } else
                            {
                                DPRINTF("NOT FLAGGED\n"); 
                            }
                    }
                }
            }
        }
    } else {
        DPRINTF("%s: memory allocation of %d bytesfailed\n", __func__, size); 
        result = -ENOMEM;
        close(fd);
    }
    if (buf != NULL)
        free(buf);
    lua_pushinteger(L, result);
    return 1;
}

static const luaL_Reg Secrman_functions[] = {
    {"init", lua_initsecrman},
    {"deinit", lua_deinitsecrman},
    {"downloadfile", lua_secrdownloadfile},
    //{"signKELFfile", lua_signKELFfile},
    {0, 0}};

void luaSecrMan_init(lua_State *L)
{

    lua_newtable(L);
    luaL_setfuncs(L, Secrman_functions, 0);
    lua_setglobal(L, "Secrman");

    lua_pushinteger(L, JAP_ROM_100);
    lua_setglobal(L, "JAP_ROM_100");

    lua_pushinteger(L, JAP_ROM_101);
    lua_setglobal(L, "JAP_ROM_101");

    lua_pushinteger(L, JAP_ROM_120);
    lua_setglobal(L, "JAP_ROM_120");

    lua_pushinteger(L, JAP_STANDARD);
    lua_setglobal(L, "JAP_STANDARD");

    lua_pushinteger(L, USA_ROM_110);
    lua_setglobal(L, "USA_ROM_110");

    lua_pushinteger(L, USA_ROM_120);
    lua_setglobal(L, "USA_ROM_120");

    lua_pushinteger(L, USA_STANDARD);
    lua_setglobal(L, "USA_STANDARD");

    lua_pushinteger(L, EUR_ROM_120);
    lua_setglobal(L, "EUR_ROM_120");

    lua_pushinteger(L, EUR_STANDARD);
    lua_setglobal(L, "EUR_STANDARD");

    lua_pushinteger(L, CHN_STANDARD);
    lua_setglobal(L, "CHN_STANDARD");

    lua_pushinteger(L, SYSTEM_UPDATE_COUNT);
    lua_setglobal(L, "SYSTEM_UPDATE_COUNT");
}
