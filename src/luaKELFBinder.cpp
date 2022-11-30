#include "include/luaplayer.h"
#include "include/baexec-system_paths.h"
#include "include/luaKELFBinder.h"
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <osd_config.h>
#include "include/dbgprintf.h"

static int KELFBinderHelperFunctionsInited = false;
static unsigned long int ROMVERSION;
static unsigned int MACHINETYPE;
// static int ROMYEAR, ROMMONTH, ROMDAY;
static char ROMREGION;

#define ROMVER_LEN 16
#define GET_MACHINE_TYPE(X)          \
    (X == 'C') ? MACHINETYPE::CEX :  \
    (X == 'D') ? MACHINETYPE::DEX :  \
    (X == 'T') ? MACHINETYPE::TOOL : \
                 UNKNOWN

/// NOTE: sony made asian machines to use the USA region folder prefixes
#define GET_CONSOLE_REGION(X)              \
    (X == 'J') ? CONSOLE_REGIONS::JAPAN :  \
    (X == 'A') ? CONSOLE_REGIONS::USA :    \
    (X == 'H') ? CONSOLE_REGIONS::ASIA :   \
    (X == 'E') ? CONSOLE_REGIONS::EUROPE : \
    (X == 'C') ? CONSOLE_REGIONS::CHINA :  \
                 UNKNOWN

static int lua_KELFBinderInit(lua_State *L)
{
    int argc = lua_gettop(L);
#ifndef SKIP_ERROR_HANDLING
    if (argc != 1)
        return luaL_error(L, "wrong number of arguments");
#endif
    const char *ROMVER = luaL_checkstring(L, 1);
    char ROMVNUM[4 + 1];
    ROMREGION = GET_CONSOLE_REGION(ROMVER[4]);
    MACHINETYPE = GET_MACHINE_TYPE(ROMVER[5]);
    strncpy(ROMVNUM, ROMVER, 4);
    ROMVNUM[4] = '\0';
    ROMVERSION = strtoul(ROMVNUM, NULL, 10); // convert ROM version to unsigned long int for further use on automatic Install, use hex numbers to compare!! (eg: to check for rom 1.20 do ROMVERSION == 0x120)
    KELFBinderHelperFunctionsInited = true;
    return 1;
}

static int lua_KELFBinderDeInit(lua_State *L)
{
    int argc = lua_gettop(L);
#ifndef SKIP_ERROR_HANDLING
    if (argc != 0)
        return luaL_error(L, "wrong number of arguments");
#endif
    return 1;
}

static int lua_calcsysupdatepath(lua_State *L)
{
    DPRINTF(__func__);
    int argc = lua_gettop(L);
#ifndef SKIP_ERROR_HANDLING
    if (argc != 0)
        return luaL_error(L, "wrong number of arguments");
#endif

    if (!KELFBinderHelperFunctionsInited)
        return luaL_error(L, "error initializing kelfbinder helper service!");

    if (ROMREGION == CONSOLE_REGIONS::JAPAN) {
        switch (ROMVERSION) {
            case 100:
                lua_pushstring(L, sysupdate_paths[SYSUPDATE_COUNT::JAP_ROM_100]);
                break;
            case 101:
                lua_pushstring(L, sysupdate_paths[SYSUPDATE_COUNT::JAP_ROM_101]);
                break;
            case 120:
                lua_pushstring(L, sysupdate_paths[SYSUPDATE_COUNT::JAP_ROM_120]);
                break;
            default:
                lua_pushstring(L, sysupdate_paths[SYSUPDATE_COUNT::JAP_STANDARD]);
                break;
        }

    } else if (ROMREGION == CONSOLE_REGIONS::EUROPE) {
        switch (ROMVERSION) {
            case 120:
                lua_pushstring(L, sysupdate_paths[SYSUPDATE_COUNT::EUR_ROM_120]);
                break;

            default:
                lua_pushstring(L, sysupdate_paths[SYSUPDATE_COUNT::EUR_STANDARD]);
                break;
        }

    } else if (ROMREGION == CONSOLE_REGIONS::CHINA) {
        lua_pushstring(L, sysupdate_paths[SYSUPDATE_COUNT::CHN_STANDARD]);

    } else if ((ROMREGION == CONSOLE_REGIONS::USA) || (ROMREGION == CONSOLE_REGIONS::ASIA)) {
        switch (ROMVERSION) {
            case 110:
                lua_pushstring(L, sysupdate_paths[SYSUPDATE_COUNT::USA_ROM_110]);
                break;

            case 120:
                lua_pushstring(L, sysupdate_paths[SYSUPDATE_COUNT::USA_ROM_120]);
                break;

            default:
                lua_pushstring(L, sysupdate_paths[SYSUPDATE_COUNT::USA_STANDARD]);
        }
    } else {
        return luaL_error(L, "SYSTEM REGION IS UNKNOWN\nCONTACT THE DEVELOPER!");
    }
    return 1;
}


static int lua_getsystemregion(lua_State *L)
{
    DPRINTF(__func__);
    lua_pushinteger(L, ROMREGION);
    return 1;
}

static int lua_getsystemregionString(lua_State *L)
{
    DPRINTF(__func__);
    switch (ROMREGION) {

        case CONSOLE_REGIONS::JAPAN:
            lua_pushstring(L, "Japan");
            break;

        case CONSOLE_REGIONS::USA:
            lua_pushstring(L, "USA");
            break;

        case CONSOLE_REGIONS::ASIA:
            lua_pushstring(L, "Asia");
            break;

        case CONSOLE_REGIONS::CHINA:
            lua_pushstring(L, "China");
            break;

        default:
            lua_pushstring(L, "UNKNOWN!");
            break;
    }
    return 1;
}

static int lua_getromversion(lua_State *L)
{
    DPRINTF(__func__);
    lua_pushinteger(L, ROMVERSION);
    return 1;
}

static int lua_getosdconfigLNG(lua_State *L)
{
    DPRINTF(__func__);
    lua_pushinteger(L, configGetLanguage());
    return 1;
}

static const luaL_Reg KELFBinder_functions[] = {

    {"init", lua_KELFBinderInit},
    {"deinit", lua_KELFBinderDeInit},
    {"calculateSysUpdatePath", lua_calcsysupdatepath},
    {"getsystemregion", lua_getsystemregion},
    {"getsystemregionString", lua_getsystemregionString},
    {"getROMversion", lua_getromversion},
    {"getsystemLanguage", lua_getosdconfigLNG},
    {0, 0}};

void luaKELFBinder_init(lua_State *L)
{
    lua_newtable(L);
    luaL_setfuncs(L, KELFBinder_functions, 0);
    lua_setglobal(L, "KELFBinder");
}