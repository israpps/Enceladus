#include <stdlib.h>
#include <sifrpc.h>
#include <tamtypes.h>
#include <string.h>
#include <kernel.h>
#include <loadfile.h>
#include <stdio.h>
#include "include/luaplayer.h"
#include "include/mechaemu_rpc.h"

#define LUA_FUN(x) static int x(lua_State *L)

static SifRpcClientData_t MechaEmuRPC;
static int rpc_initialized = false;

LUA_FUN(lua_connect_rpc) {
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

LUA_FUN(lua_disconnect_rpc) {
    memset(&MechaEmuRPC, 0, sizeof(SifRpcClientData_t));
	return 1;
}

void* current_kelf = NULL;

#define RPC_BUFPARAM(x) &x, sizeof(x)
int mechaemu_downloadfile(int port, int slot, void* KELFPointer)
{
    CHECK_RPC_INIT();

    struct DownLoadFileParam pkt;
    memset(&pkt, 0, sizeof(pkt));

    pkt.port = port;
    pkt.slot = slot;
    memcpy(pkt.buffer, KELFPointer, sizeof(pkt.buffer)); //put 1kilobyte of the KELF into the RPC

    if (SifCallRpc(&MechaEmuRPC, SECRME_DOWNLOADFILE, 0, RPC_BUFPARAM(pkt), RPC_BUFPARAM(pkt), NULL, NULL) < 0)
    {
        DPRINTF("%s: RPC ERROR\n", __FUNCTION__);
        return -SCE_ECALLMISS;
    }
    if (pkt.result) memcpy(KELFPointer, pkt.buffer, sizeof(pkt.buffer)); //copy back the kilobyte from RPC to the original pointer, kbit and kc changed
    return pkt.result;
}


LUA_FUN(lua_ReadKELF) {

}
LUA_FUN(lua_WriteKELF) {

}

LUA_FUN(lua_FreeKELF) {
    if (current_kelf)
    {
        free(current_kelf);
        current_kelf = NULL;
    }
}

LUA_FUN(lua_BindKELF) {

}

LUA_FUN(lua_ChangeKeyset) {

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

void luaTimer_init(lua_State *L){
	lua_newtable(L);
	luaL_setfuncs(L, Mecha_func, 0);
	lua_setglobal(L, "Mecha");
}
