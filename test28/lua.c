#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

/*
// 28.1: Write a C program that reads a Lua file defining a function f from numbers to numbers
// and plots that function. (You do not need to do anything fancy; the program can plot the results printing
// ASCII asterisks as we did in the section called “Compilation”.)

void plotfunc(lua_State *L, const char *fname){
	int isnum, x, z;
	if (luaL_loadfile(L, fname) || lua_pcall(L, 0, 0, 0)){
		// error(L, "Cannot load file. %s", lua_tostring(L, -1));
	}

	lua_getglobal(L, "f");
	x = 10;
	lua_pushnumber(L, x);

	if (lua_pcall(L, 1, 1, 0) != LUA_OK){
		// error(L, "error running function 'f': %s", lua_tostring(L, -1));
	}

	z = lua_tointegerx(L, -1, &isnum);
	if (!isnum)
		// error(L, "function 'f' should return a number");
	lua_pop(L, 1); // pop returned value
	
	for (int i = 0; i < z; ++i)
		printf("*");
	printf("\n");
}

int main(void) {
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);

	plotfunc(L, "test28-1.lua");

	lua_close(L);
	return 0;
}

//*/


//*
// 28.2: Write a C program that reads a Lua file defining a function f from numbers to numbers
// and plots that function. (You do not need to do anything fancy; the program can plot the results printing
// ASCII asterisks as we did in the section called “Compilation”.)

void plotfunc(lua_State *L, const char *fname){
	int isnum, x, z;
	if (luaL_loadfile(L, fname) || lua_pcall(L, 0, 0, 0)){
		// error(L, "Cannot load file. %s", lua_tostring(L, -1));
	}

	lua_getglobal(L, "f");
	x = 10;
	lua_pushnumber(L, x);

	if (lua_pcall(L, 1, 1, 0) != LUA_OK){
		// error(L, "error running function 'f': %s", lua_tostring(L, -1));
	}

	z = lua_tointegerx(L, -1, &isnum);
	if (!isnum)
		// error(L, "function 'f' should return a number");
	lua_pop(L, 1); /* pop returned value */
	
	for (int i = 0; i < z; ++i)
		printf("*");
	printf("\n");
}

int main(void) {
	char buff[256];
	int error;
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);

	plotfunc(L, "test28-1.lua");

	while(fgets(buff, sizeof(buff), stdin) != NULL){
		error = luaL_loadstring(L, buff) || lua_pcall(L, 0, 0, 0);
		if (error) {
			fprintf(stderr, "%s\n", lua_tostring(L, -1));
			lua_pop(L, 1);
		}
	}

	lua_close(L);
	return 0;
}

//*/