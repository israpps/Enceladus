#include <kernel.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <malloc.h>

#include "include/luaplayer.h"
#include "include/dprintf.h"

static lua_State *L;

int test_error(lua_State * L) {
    int n = lua_gettop(L);
    int i;

    DPRINTF("Got LUA error.\n");

    if (n == 0) {
        DPRINTF("Stack is empty.\n");
        return 0;
    }

    for (i = 1; i <= n; i++) {
        DPRINTF("%i: ", i);
        switch(lua_type(L, i)) {
        case LUA_TNONE:
            DPRINTF("Invalid");
            break;
        case LUA_TNIL:
            DPRINTF("(Nil)");
            break;
        case LUA_TNUMBER:
            DPRINTF("(Number) %f", lua_tonumber(L, i));
            break;
        case LUA_TBOOLEAN:
            DPRINTF("(Bool)   %s", (lua_toboolean(L, i) ? "true" : "false"));
            break;
        case LUA_TSTRING:
            DPRINTF("(String) %s", lua_tostring(L, i));
            break;
        case LUA_TTABLE:
            DPRINTF("(Table)");
            break;
        case LUA_TFUNCTION:
            DPRINTF("(Function)");
            break;
        default:
            DPRINTF("Unknown");
        }

        DPRINTF("\n");
    }
	SleepThread();
    return 0;
}

const char * runScript(const char* script, bool isStringBuffer )
{	
    DPRINTF("Creating luaVM... \n");

  	L = luaL_newstate();
	if (!L) return "Failed to create LUA STATE\n";
    //lua_atpanic(L, test_error);
	
	  // Init Standard libraries
	  luaL_openlibs(L);

    DPRINTF("Loading libs... ");

	  // init graphics
    luaGraphics_init(L);
    luaControls_init(L);
	luaScreen_init(L);
    luaTimer_init(L);
    luaSystem_init(L);
    luaSound_init(L);
    luaRender_init(L);
    	
    DPRINTF("done !\n");
     
	if(!isStringBuffer){
        DPRINTF("Loading script : `%s'\n", script);
	}

	int s = 0;
	const char * errMsg =(const char*)malloc(sizeof(char)*512);

	if(!isStringBuffer) s = luaL_loadfile(L, script);
	else {
    s = luaL_loadbuffer(L, script, strlen(script), NULL);
  }

		
	if (s == 0) s = lua_pcall(L, 0, LUA_MULTRET, 0);

	if (s) {
		sprintf((char*)errMsg, "%s\n", lua_tostring(L, -1));
    DPRINTF("%s\n", lua_tostring(L, -1));
		lua_pop(L, 1); // remove error message
	}
	lua_close(L);
	
	return errMsg;
}
