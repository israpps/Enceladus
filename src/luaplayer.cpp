#include <kernel.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <malloc.h>

#include "include/luaplayer.h"

static lua_State *L;
#define DUAL_PRINTF(x...) \
	scr_printf(x); \
	printf(x)

int test_error(lua_State * L) {
    int n = lua_gettop(L);
    int i;

	scr_setfontcolor(0x0000ff);
	scr_setCursor(0);
	scr_clear();
    printf("ERROR.\n");

    if (n == 0) {
        DUAL_PRINTF("Stack is empty.\n");
    }

    for (i = 1; i <= n; i++) {
        printf("%i: ", i);
        switch(lua_type(L, i)) {
        case LUA_TNONE:
            DUAL_PRINTF("Invalid");
            break;
        case LUA_TNIL:
            DUAL_PRINTF("(Nil)");
            break;
        case LUA_TNUMBER:
            DUAL_PRINTF("(Number) %f", lua_tonumber(L, i));
            break;
        case LUA_TBOOLEAN:
            DUAL_PRINTF("(Bool)   %s", (lua_toboolean(L, i) ? "true" : "false"));
            break;
        case LUA_TSTRING:
            DUAL_PRINTF(" %s", lua_tostring(L, i));
            break;
        case LUA_TTABLE:
            DUAL_PRINTF("(Table)");
            break;
        case LUA_TFUNCTION:
            DUAL_PRINTF("(Function)");
            break;
        default:
            DUAL_PRINTF("<UNKNOWN>");
        }

        DUAL_PRINTF("\n");
    }

    SleepThread();
}

const char * runScript(const char* script, bool isStringBuffer )
{	
    printf("Creating luaVM... \n");

  	L = luaL_newstate();
	
	  // Init Standard libraries
	  luaL_openlibs(L);

    printf("Loading libs... ");
    //lua_atpanic(L, test_error);

	  // init graphics
    luaGraphics_init(L);
    luaControls_init(L);
	luaScreen_init(L);
    luaTimer_init(L);
    luaSystem_init(L);
#ifdef F_Sound
    luaSound_init(L);
#endif
#ifdef F_Render
    luaRender_init(L);
#endif
    	
    printf("done !\n");

	if(!isStringBuffer){
        printf("Loading script : `%s'\n", script);
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
    printf("%s\n", lua_tostring(L, -1));
		lua_pop(L, 1); // remove error message
	}
	lua_close(L);
	
	return errMsg;
}
