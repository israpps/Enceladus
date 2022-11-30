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

extern "C" {
#include "include/libsecr.h"
}

static int lua_initsecrman(lua_State *L)
{
	printf("INITIALIZING SECRMAN\n");
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
	printf("DEINITIALIZING SECRMAN\n");
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
    int result, InitSemaID, mcInitRes;

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
        // DEBUG_PRINTF("Error signing file.\n");
        result = -EINVAL;
    }

    return result;
}

int installKELF(const char* filepath, const char* installpath)
{
    int fd, result;
    ssize_t READED;
    unsigned char* PTR;
    fd = open(filepath, O_RDONLY);
    if (fd < 0)
        return -EIO;
	lseek(fd, 0, SEEK_CUR); // make sure we seek from start
	uint32_t size = lseek(fd, 0, SEEK_END);
	lseek(fd, 0, SEEK_CUR); // go back to start so read() gets the job done

    PTR = (unsigned char *)malloc(size);
    if (PTR != NULL)
    {
        READED = read(fd, PTR, size);
        if (READED != size)
        {
            result = -EIO;
            printf("%s: ERROR reading KELF, expected to read %d bytes, but %d bytes were readed", __func__, size, READED);
        } else
        {
            result = SignKELF(PTR, size, installpath[2] - '0', 0);
        }
    } else {
        result = -2;
    }
    close(fd);
    return result;
}

static int lua_installKELF(lua_State *L)
{
    int argc = lua_gettop(L);
#ifndef SKIP_ERROR_HANDLING
    if (argc != 2)
        return luaL_error(L, "wrong number of arguments");
#endif

return 0;
}

static void GetKbitAndKc(void *buffer, u8 *Kbit, u8 *Kc)
{
    int offset;
    unsigned char OffsetByte;
    SecrKELFHeader_t *header;

    header = (SecrKELFHeader_t *)buffer;
    offset = 0x20;
    if (header->BIT_count > 0)
        offset += header->BIT_count * 0x10;
    if ((*(unsigned int *)&header->flags) & 1) {
        OffsetByte = ((u8 *)buffer)[offset];
        offset += OffsetByte + 1;
    }
    if (((*(unsigned int *)&header->flags) & 0xF000) == 0)
        offset += 8;

    memcpy(Kbit, &((u8 *)buffer)[offset], 16);
    memcpy(Kc, &((u8 *)buffer)[offset + 16], 16);
}

static int SetKbitAndKc(void *buffer, u8 *Kbit, u8 *Kc)
{
    int offset;
    unsigned char OffsetByte;
    SecrKELFHeader_t *header;

    header = (SecrKELFHeader_t *)buffer;
    offset = 0x20;
    if (header->BIT_count > 0)
        offset += header->BIT_count * 0x10;
    if ((*(unsigned int *)&header->flags) & 1) {
        OffsetByte = ((u8 *)buffer)[offset];
        offset += OffsetByte + 1;
    }
    if (((*(unsigned int *)&header->flags) & 0xF000) == 0)
        offset += 8;

    memcpy(&((u8 *)buffer)[offset], Kbit, 16);
    memcpy(&((u8 *)buffer)[offset + 16], Kc, 16);
}

static int lua_signKELFfile(lua_State *L)
{

}

static const luaL_Reg Secrman_functions[] = {
    {"init", lua_initsecrman},
    {"deinit", lua_deinitsecrman},
    {"installKELF", lua_installKELF},
    //{"signKELFfile", lua_signKELFfile},
    {0, 0}};

void luaSecrMan_init(lua_State *L)
{

    lua_newtable(L);
    luaL_setfuncs(L, Secrman_functions, 0);
    lua_setglobal(L, "Secrman");
}

