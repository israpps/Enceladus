
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <tamtypes.h>
#include <loadfile.h>
#include <malloc.h>
#include <assert.h>
#define NEWLIB_PORT_AWARE
#include <fileXio_rpc.h>
#include <fileio.h>

#include "include/dbgprintf.h"
#include "include/luaplayer.h"


int mnt(const char* path, int index, int openmod);

static int MountPart(lua_State *L)
{
    int indx = 0, openmod = FIO_MT_RDWR;
    const char* mount;
    int argc = lua_gettop(L);
	if (argc > 1 && argc < 4) return luaL_error(L, "%s: wrong number of arguments, expected 1 or 2", __func__); 
    
    mount = luaL_checkstring(L, 1);
    if (argc >= 2) indx = luaL_checkinteger(L, 2);
    if (argc == 3) openmod = luaL_checkinteger(L, 3);

    lua_pushinteger(L, mnt(mount, indx, openmod));
    return 1;

}

static int UmountPart(lua_State *L)
{
    char PFS[6] = "pfs0:";
	if (lua_gettop(L) != 1) return luaL_error(L, "%s: wrong number of arguments, expected 1", __func__);

    PFS[3] = '0' + luaL_checkinteger(L, 1);
    lua_pushinteger(L, fileXioUmount(PFS));
    return 1;
}

int mnt(const char* path, int index, int openmod)
{
    char PFS[5+1] = "pfs0:";
    if (index > 0)
        PFS[3] = '0' + index;

    DPRINTF("Mounting '%s' into pfs%d:\n", path, index);
    if (fileXioMount(PFS, path, openmod) < 0) // mount
    {
        DPRINTF("Mount failed. unmounting trying again...\n");
        if (fileXioUmount(PFS) < 0) //try to unmount then mount again in case it got mounted by something else
        {
            DPRINTF("Unmount failed!!!\n");
        }
        if (fileXioMount(PFS, path, openmod) < 0)
        {
            DPRINTF("mount failed again!\n");
            return -1;
        } else {
            DPRINTF("Second mount succed!\n");
        }
    } else DPRINTF("mount successfull on first attemp\n");
    return 0;
}

static const luaL_Reg HDD_functions[] = {
  	{"MountPartition",    MountPart},
  	{"UMountPartition",    UmountPart},
    {0, 0}
};

void luaHDD_init(lua_State *L) 
{

    lua_newtable(L);
	luaL_setfuncs(L, HDD_functions, 0);
	lua_setglobal(L, "HDD");

	lua_pushinteger(L, FIO_MT_RDWR);
	lua_setglobal (L, "FIO_MT_RDWR");

	lua_pushinteger(L, FIO_MT_RDONLY);
	lua_setglobal (L, "FIO_MT_RDONLY");
}