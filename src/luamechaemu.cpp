#include <stdlib.h>
#include <sifrpc.h>
#include <tamtypes.h>
#include <string.h>
#include <kernel.h>
#include <loadfile.h>
#include <stdio.h>
#include "include/luaplayer.h"
#include "include/mechaemu_rpc.h"
#define RPCGUARD() if (!rpc_initialized) return luaL_error(L, "attempt to call %s while RPC service is not bound", __FUNCTION__)
static SifRpcClientData_t MechaEmuRPC;
static int rpc_initialized = false;

static int lua_connect_rpc(lua_State *L) {
    int retries = 100;
    if (!rpc_initialized) {
        int E;
	    while(retries--)
	    {
	    	if((E = SifBindRpc(&MechaEmuRPC, MECHAEMU_RPC_IRX, 0)) < 0)
            {
                printf("Failed to bind RPC server for MECHAEMU (%d)\n", E);
	    		return SCE_EBINDMISS;
            }
        
	    	if(MechaEmuRPC.server != NULL)
	    		break;
        
	    	nopdelay();
	    }
	    rpc_initialized = retries;
    }

	lua_pushboolean(L, (bool)rpc_initialized);
	return 1;
}

static int lua_disconnect_rpc(lua_State *L) {
    memset(&MechaEmuRPC, 0, sizeof(SifRpcClientData_t));
	return 1;
}

void* current_kelf = NULL;

#define RPC_BUFPARAM(x) &x, sizeof(x)
int mechaemu_downloadfile(int port, int slot, void* KELFPointer) {

    struct DownLoadFileParam pkt;
    memset(&pkt, 0, sizeof(pkt));

    pkt.port = port;
    pkt.slot = slot;
    memcpy(pkt.buffer, KELFPointer, sizeof(pkt.buffer)); //put 1kilobyte of the KELF into the RPC

    if (SifCallRpc(&MechaEmuRPC, SECRME_DOWNLOADFILE, 0, RPC_BUFPARAM(pkt), RPC_BUFPARAM(pkt), NULL, NULL) < 0)
    {
        printf("%s: RPC ERROR\n", __FUNCTION__);
        return -SCE_ECALLMISS;
    }
    if (pkt.result) memcpy(KELFPointer, pkt.buffer, sizeof(pkt.buffer)); //copy back the kilobyte from RPC to the original pointer, kbit and kc changed
    return pkt.result;
}

static int lua_ReadKELF(lua_State *L) {
    return 0;
}

static int lua_WriteKELF(lua_State *L) {
    return 0;
}

static int lua_FreeKELF(lua_State *L) {
    if (current_kelf)
    {
        free(current_kelf);
        current_kelf = NULL;
    }
    return 0;
}

static int lua_BindKELF(lua_State *L) {
    return 0;
}

static int lua_ChangeKeyset(lua_State *L) {
    RPCGUARD();
    struct keyscontrol pkt;
    memset(&pkt, 0, sizeof(pkt));
	int argc = lua_gettop(L);
	if (argc != 1) return luaL_error(L, "wrong number of arguments");
    pkt.newkyey = luaL_checkinteger(L, 1);
    if (SifCallRpc(&MechaEmuRPC, SECRME_CONTROLKEYS, 0, RPC_BUFPARAM(pkt), RPC_BUFPARAM(pkt), NULL, NULL) < 0)
    {
        printf("%s: RPC ERROR\n", __FUNCTION__);
        lua_pushnil(L);
        return 1;
    }
	lua_pushinteger(L, pkt.currentkey);
    return 1;
}

//Register our Timer Functions
static const luaL_Reg Mecha_func[] = {
  {"connect_rpc",    lua_connect_rpc},
  {"disconnect_rpc", lua_disconnect_rpc},
  {"ReadKELF",       lua_ReadKELF},
  {"WriteKELF",      lua_WriteKELF},
  {"FreeKELF",       lua_FreeKELF},
  {"BindKELF",       lua_BindKELF},
  {"ChangeKeyset",   lua_ChangeKeyset},
  {0, 0}
};

void luaMechaEmuInit(lua_State *L) {
	lua_newtable(L);
	luaL_setfuncs(L, Mecha_func, 0);
	lua_setglobal(L, "Mecha");
}
