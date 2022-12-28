#include "include/luaplayer.h"
#include "include/baexec-system_paths.h"
#include "include/luaKELFBinder.h"
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <libmc.h>
#include <osd_config.h>
#include "include/dbgprintf.h"
extern "C" {
#include "modelname.h"
}

static int KELFBinderHelperFunctionsInited = false;
static unsigned long int ROMVERSION;
static unsigned int MACHINETYPE_;
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
    DPRINTF("%s: start\n", __func__);
    int argc = lua_gettop(L);
#ifndef SKIP_ERROR_HANDLING
    if (argc != 1)
        return luaL_error(L, "wrong number of arguments");
#endif
    const char *ROMVER = luaL_checkstring(L, 1);
    char ROMVNUM[4 + 1];
    ROMREGION = GET_CONSOLE_REGION(ROMVER[4]);
    MACHINETYPE_ = GET_MACHINE_TYPE(ROMVER[5]);
    strncpy(ROMVNUM, ROMVER, 4);
    ROMVNUM[4] = '\0';
    ROMVERSION = strtoul(ROMVNUM, NULL, 10); // convert ROM version to unsigned long int for further use on automatic Install, use hex numbers to compare!! (eg: to check for rom 1.20 do ROMVERSION == 0x120)
    KELFBinderHelperFunctionsInited = true;
    return 1;
}

static int lua_KELFBinderDeInit(lua_State *L)
{
    DPRINTF("%s: start\n", __func__);
    int argc = lua_gettop(L);
#ifndef SKIP_ERROR_HANDLING
    if (argc != 0)
        return luaL_error(L, "wrong number of arguments");
#endif
    return 1;
}

static int lua_calcsysupdatepath(lua_State *L)
{
    DPRINTF("%s: start\n", __func__);
    int argc = lua_gettop(L);
    if (!KELFBinderHelperFunctionsInited)
        return luaL_error(L, "error kelfbinder helper service needs to be initialized first!\n");

    if (argc == 1) // a specific install has been specified, check it
    {
        int index = luaL_checkinteger(L, 1);
        if ((index >= 0) && (index < SYSTEM_UPDATE_COUNT)) // if it is inside of boundaries
        {
            lua_pushstring(L, sysupdate_paths[index]);
            return 1;
        } else {return luaL_error(L, "%s: invalid system update ID was requested (%d)\n", __FUNCTION__, index);}
    } // if no argumment was passed, calculate system update based on current system
    int ver = ROMVERSION, region = ROMREGION;
    if (region == CONSOLE_REGIONS::JAPAN) {
        switch (ver) {
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

    } else if (region == CONSOLE_REGIONS::EUROPE) {
        switch (ver) {
            case 120:
                lua_pushstring(L, sysupdate_paths[SYSUPDATE_COUNT::EUR_ROM_120]);
                break;

            default:
                lua_pushstring(L, sysupdate_paths[SYSUPDATE_COUNT::EUR_STANDARD]);
                break;
        }

    } else if (region == CONSOLE_REGIONS::CHINA) {
        lua_pushstring(L, sysupdate_paths[SYSUPDATE_COUNT::CHN_STANDARD]);

    } else if ((region == CONSOLE_REGIONS::USA) || (region == CONSOLE_REGIONS::ASIA)) {
        switch (ver) {
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
    DPRINTF("%s: start\n", __func__);
    lua_pushinteger(L, ROMREGION);
    return 1;
}

static int lua_getmachinetypeStr(lua_State *L)
{
    DPRINTF("%s: start\n", __func__);
    switch (MACHINETYPE_)
    {
    case MACHINETYPE::CEX:
        lua_pushstring(L, "CEX");
        break;
    case MACHINETYPE::DEX:
        lua_pushstring(L, "DEX");
        break;
    case MACHINETYPE::TOOL:
        lua_pushstring(L, "TOOL");
        break;
    default:
        lua_pushstring(L, "?");
        break;
    }
    return 1;
}

static int lua_getsystemregionString(lua_State *L)
{
    DPRINTF("%s: start\n", __func__);
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

static int lua_getsystemupdatefolder(lua_State *L)
{
    DPRINTF("%s: start\n", __func__);
    switch (ROMREGION) {
        case CONSOLE_REGIONS::JAPAN:
            lua_pushstring(L, "BIEXEC-SYSTEM");
            break;

        case CONSOLE_REGIONS::ASIA:
        case CONSOLE_REGIONS::USA:
            lua_pushstring(L, "BAEXEC-SYSTEM");
            break;
            
        case CONSOLE_REGIONS::CHINA:
            lua_pushstring(L, "BCEXEC-SYSTEM");
            break;

        default:
            return luaL_error(L, "SYSTEM REGION IS UNKNOWN\nCONTACT THE DEVELOPER!");
            break;
    }
    return 1;
}

static int lua_getDVDPlayerUpdatefolder(lua_State *L)
{
    int region;
    if (lua_gettop(L) < 1)
        region = ROMREGION;
    else
        region = luaL_checkinteger(L, 1);

    DPRINTF("%s: start\n", __func__);
    switch (region) {
        case CONSOLE_REGIONS::JAPAN:
            lua_pushstring(L, "BIEXEC-DVDPLAYER");
            break;

        case CONSOLE_REGIONS::ASIA:
        case CONSOLE_REGIONS::USA:
            lua_pushstring(L, "BAEXEC-DVDPLAYER");
            break;
            
        case CONSOLE_REGIONS::CHINA:
            lua_pushstring(L, "BCEXEC-DVDPLAYER");
            break;

        default:
            return luaL_error(L, "SYSTEM REGION IS UNKNOWN\nCONTACT THE DEVELOPER!");
            break;
    }
    return 1;
}

static int lua_getromversion(lua_State *L)
{
    DPRINTF("%s: start\n", __func__);
    lua_pushinteger(L, ROMVERSION);
    return 1;
}

static int lua_getosdconfigLNG(lua_State *L)
{
    DPRINTF("%s: start\n", __func__);
    int lang = configGetLanguage();
    DPRINTF("%s: Language ID is %d\n", __func__, lang);
    lua_pushinteger(L, lang);
    return 1;
}

static int lua_setsysupdatefoldprops(lua_State *L)
{	
    DPRINTF("%s: start\n", __func__);
    int argc = lua_gettop(L);
	if (argc != 3) 
        return luaL_error(L, "lua_createsysupdatefolder takes 3 argumments\n");
    int result;
    int port = luaL_checkinteger(L, 1);
    int slot = luaL_checkinteger(L, 2);
    const char* path = luaL_checkstring(L, 3);
    sceMcTblGetDir table;
    // Set desired file attributes.
    table.AttrFile = sceMcFileAttrReadable | sceMcFileAttrWriteable | sceMcFileAttrExecutable | sceMcFileAttrDupProhibit | sceMcFileAttrSubdir | sceMcFile0400;
    if ((result = mcSetFileInfo(port, slot, path, &table, sceMcFileInfoAttr)) == 0) {
        DPRINTF("mcSetFileInfo: result was %d\n", result);
        mcSync(0, NULL, &result);
    }

    return result;
}

static int lua_initConsoleModel(lua_State *L)
{	
    ModelNameInit();
    return 1;
}

static int lua_getConsoleModel(lua_State *L)
{
    const char* model = ModelNameGet();
    lua_pushstring(L, model);
    return 1;
}

static const luaL_Reg KELFBinder_functions[] = {
    {"init", lua_KELFBinderInit},
    {"deinit", lua_KELFBinderDeInit},
    {"calculateSysUpdatePath", lua_calcsysupdatepath},
    {"setSysUpdateFoldProps", lua_setsysupdatefoldprops},
    {"getsysupdatefolder", lua_getsystemupdatefolder},
    {"getsystemregion", lua_getsystemregion},
    {"getsystemregionString", lua_getsystemregionString},
    {"getROMversion", lua_getromversion},
    {"getsystemLanguage", lua_getosdconfigLNG},
    {"InitConsoleModel", lua_initConsoleModel},
    {"getConsoleModel", lua_getConsoleModel},
    {"getDVDPlayerFolder", lua_getDVDPlayerUpdatefolder},
    {"getMachineType", lua_getmachinetypeStr},
    {0, 0}
};

void luaKELFBinder_init(lua_State *L)
{
    lua_newtable(L);
    luaL_setfuncs(L, KELFBinder_functions, 0);
    lua_setglobal(L, "KELFBinder");
}