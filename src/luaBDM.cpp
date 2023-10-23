
#define NEWLIB_PORT_AWARE
#include <fileXio_rpc.h>
#include <fileio.h>
#include <errno.h>
#include "include/luaplayer.h"
#include <string.h>
#include <unistd.h>
#include <usbhdfsd-common.h>

enum DEVENUM{USB = 0, MX4SIO, ILINK, UDPBD, AMMOUNT};
const char* DEVICES_ALIAS[DEVENUM::AMMOUNT] = {"usb", "sdc", "sd", "udp"};

int getBDID(int mass_index) {
    int dd;
    char mass_path[8] = "massX:";
	char DEVID[5];
    mass_path[4] = '0' + mass_index;
    if ((dd = fileXioDopen(mass_path)) >= 0) {
        int *intptr_ctl = (int *)DEVID;
        *intptr_ctl = fileXioIoctl(dd, USBMASS_IOCTL_GET_DRIVERNAME, (void*)"");
        close(dd);
        for (int bdid = 0; bdid < DEVENUM::AMMOUNT; bdid++)
        {
	    	if (!strcmp(DEVID, DEVICES_ALIAS[bdid])) {
	    		printf("%s: Found '%s' device at mass%d:/\n", __func__, DEVICES_ALIAS[bdid], mass_index);
	    		return bdid;
	    	}
        }
    } else {
        printf("%s: failed to open mass%d:/ (%d)\n", __FUNCTION__, dd, mass_index);
    }
    return -ENODEV;
}

int LookForBDMDevice(int bdid, int start_index, int final_index) {
    int x = (start_index >= 0 && start_index <= 20) ? start_index : 0; // make sure initial value is inside sane range (0-20)
    int ending_index = (final_index <= 20) ? final_index : 20; // avoid senseless iterations, BDM.IRX has a max of 20 BDs
    for (; x < ending_index; x++)
    {
	    if (getBDID(x) == bdid) {
	    	printf("%s: Found %s device at mass%d:/\n", __func__, DEVICES_ALIAS[bdid], x);
	    	return x;
	    }
    }
    printf("%s: %s not found\n", __func__, DEVICES_ALIAS[bdid]);
    return -1;
}

static int lua_GetBDMDevice(lua_State *L) {
	int start = 0;
	int endin = 20;
	int argc = lua_gettop(L);
	if ((argc < 1) || (argc > 3)) return luaL_error(L, "%s() expects 3 args", __FUNCTION__);
	int bdid = luaL_checkinteger(L, 1);
	if (argc == 2) start = luaL_checkinteger(L, 2);
	if (argc == 3) endin = luaL_checkinteger(L, 3);
	lua_pushinteger(L, LookForBDMDevice(bdid, start, endin));
	return 1;
}
static int lua_getBDID(lua_State *L) {
	int argc = lua_gettop(L);
	if (argc != 1) return luaL_error(L, "%s() expects 1 arg", __FUNCTION__);
	int indx = luaL_checkinteger(L, 1);
	int ret = getBDID(indx);
	lua_pushinteger(L, ret);
	return 1;
}


static const luaL_Reg BDM_functions[] = {
	{"GetDeviceByType",     lua_GetBDMDevice},
	{"GetDeviceType",            lua_getBDID},
	{0, 0}
};

void luaBDMUtils_init(lua_State *L) {
	lua_newtable(L);
	luaL_setfuncs(L, BDM_functions, 0);
	lua_setglobal(L, "BDM");

	lua_pushinteger(L, DEVENUM::USB); // alias for lua code readability when calling `BDM.GetDeviceByType()`
	lua_setglobal(L, "BD_USB");
	lua_pushinteger(L, DEVENUM::MX4SIO);
	lua_setglobal(L, "BD_MX4SIO");
	lua_pushinteger(L, DEVENUM::ILINK);
	lua_setglobal(L, "BD_ILINK");
	lua_pushinteger(L, DEVENUM::UDPBD);
	lua_setglobal(L, "BD_UDPBD");
    
}
