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
	DPRINTF("INITIALIZING SECRMAN\n");
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
	DPRINTF("DEINITIALIZING SECRMAN\n");
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

/* int installKELF(const char* filepath, const char* installpath)
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
            DPRINTF("%s: ERROR reading KELF, expected to read %d bytes, but %d bytes were readed", __func__, size, READED);
        } else
        {
            result = SignKELF(PTR, size, installpath[2] - '0', 0);
        }
    } else {
        result = -2;
    }
    close(fd);
    return result;
} */

static int lua_secrdownloadfile(lua_State *L) {
    printf("\n\n\n\n\n\n\nluasecrdownloadfile: Starts\n");
	int argc = lua_gettop(L);
#ifndef SKIP_ERROR_HANDLING
	if ((argc != 4) && (argc != 5)) return luaL_error(L, "wrong number of arguments");
#endif
    int port = luaL_checkinteger(L, 1);
    int slot = luaL_checkinteger(L, 2);
    const char* file_tbo = luaL_checkstring(L, 3);
    const char* dest = luaL_checkstring(L, 4);
    int flags = 0;

    if (argc != 5)
    {
        flags = luaL_checkinteger(L, 5);
    }

	void* buf;
	int result = 0;

	int fd = open(file_tbo, O_RDONLY, 0777);
    printf("luasecrdownloadfile: input fd is %d\n", fd);
	if(fd<0){
        luaL_error(L, "CANT OPEN KELF");
	}
	int size=lseek(fd, 0, SEEK_END);
    printf("luasecrdownloadfile: KELF size is %d\n", size);
	if(size<0){
        luaL_error(L, "CANT SEEK KELF SIZE");
    }
	lseek(fd, 0, SEEK_SET);
	if((buf = memalign(64, size))!=NULL){
		if ((read(fd, buf, size)) != size) {
			luaL_error(L, "Error reading file %s.\n", file_tbo);
			close(fd);
    	} else {
			close(fd);
			if((result=SignKELF(buf, size, port, slot))<0){
				luaL_error(L, "Error signing file %s. Code: %d.\n", file_tbo, result);
				free(buf);
			}
            printf("luasecrdownloadfile: SignKELF returns %d\n", result);
            if (flags == 0)
            {
			int McFileFD = open(dest, O_WRONLY|O_CREAT|O_TRUNC);
            printf("luasecrdownloadfile: %s fd is (%d)\n",dest, McFileFD);
			int written = write(McFileFD, buf, size);
            printf("luasecrdownloadfile: written %d\n", written);
			close(McFileFD);
            } else
            {
                int x = 0, TF = 0;
                for (x=0; x<SYSTEM_UPDATE_COUNT; x++)
                {
                    TF = (1 << x);
                    if (flags & TF)
                    {
                        int McFileFD = open(sysupdate_paths[BSM2AI(TF)], O_WRONLY|O_CREAT|O_TRUNC);
                        printf("luasecrdownloadfile: %s fd is (%d)\n",sysupdate_paths[BSM2AI(TF)], McFileFD);
                        int written = write(McFileFD, buf, size);
                        printf("luasecrdownloadfile: written %d\n", written);
                        close(McFileFD);
                    }
                }
            }
		}
	} else {
		luaL_error(L, "Error allocating %u bytes of memory for file %s.\n", size, file_tbo);
	}
    if (buf != NULL)
	    free(buf);
    lua_pushinteger(L, (uint32_t)result);
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
	lua_setglobal (L, "JAP_ROM_100");

	lua_pushinteger(L, JAP_ROM_101);
	lua_setglobal (L, "JAP_ROM_101");

	lua_pushinteger(L, JAP_ROM_120);
	lua_setglobal (L, "JAP_ROM_120");

	lua_pushinteger(L, JAP_STANDARD);
	lua_setglobal (L, "JAP_STANDARD");

	lua_pushinteger(L, USA_ROM_110);
	lua_setglobal (L, "USA_ROM_110");

	lua_pushinteger(L, USA_ROM_120);
	lua_setglobal (L, "USA_ROM_120");

	lua_pushinteger(L, USA_STANDARD);
	lua_setglobal (L, "USA_STANDARD");

	lua_pushinteger(L, EUR_ROM_120);
	lua_setglobal (L, "EUR_ROM_120");
    
	lua_pushinteger(L, EUR_STANDARD);
	lua_setglobal (L, "EUR_STANDARD");

	lua_pushinteger(L, CHN_STANDARD);
	lua_setglobal (L, "CHN_STANDARD");

	lua_pushinteger(L, SYSTEM_UPDATE_COUNT);
	lua_setglobal (L, "SYSTEM_UPDATE_COUNT");

}

