#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

/*
// 27.1: Compile and run the simple stand-alone interpreter (Figure 27.1, “A bare-bones stand-alone Lua interpreter”).

int main(void) {
	char buff[256];
	int error;
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);

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


/*
// 27.2: Assume the stack is empty. What will be its contents after the following sequence of calls?

// lua_pushnumber(L, 3.5);
// lua_pushstring(L, "hello");
// lua_pushnil(L);
// lua_rotate(L, 1, -1);
// lua_pushvalue(L, -2);
// lua_remove(L, 1);
// lua_insert(L, -2);

// 27.3: 

static void stackDump (lua_State *L) {
	int i;
	int top = lua_gettop(L); // depth of the stack 
	for (i = 1; i <= top; i++) { // repeat for each level 
		int t = lua_type(L, i);
		switch (t) {
			case LUA_TSTRING: { //s trings
				printf("'%s'", lua_tostring(L, i));
				break;
			}
			case LUA_TBOOLEAN: { // Booleans
				printf(lua_toboolean(L, i) ? "true" : "false");
				break;
			}
			case LUA_TNUMBER: { // numbers
				printf("%g", lua_tonumber(L, i));
				break;
			}
			default: { // other values
				printf("%s", lua_typename(L, t));
				break;
			}
		}
		printf(" "); // put a separator
	}
	printf("\n"); // end the listing
}

int main(void) {
	lua_State *L = luaL_newstate();

	lua_pushnumber(L, 3.5);
	lua_pushstring(L, "hello");
	lua_pushnil(L);
	stackDump(L);
	lua_rotate(L, 1, -1);
	stackDump(L);
	lua_pushvalue(L, -2);
	stackDump(L);
	lua_remove(L, 1);
	stackDump(L);
	lua_insert(L, -2);
	stackDump(L);

	lua_close(L);
	return 0;
}

//*/


//*
// Exercise 27.4: Write a library that allows a script to limit the total amount of memory used by its Lua state.
// It may offer a single function, setlimit, to set that limit.
// The library should set its own allocation function. This function, before calling the original allocator,
// checks the total memory in use and returns NULL if the requested memory exceeds the limit.
// (Hint: the library can use the user data of the allocation function to keep its state: the byte count, the current
// memory limit, etc.; remember to use the original user data when calling the original allocation function.)

typedef struct UMemLimit {
	lua_Alloc frealloc;  /* function to reallocate memory */
	void *ud;         /* auxiliary data to 'frealloc' */
	size_t bytecount;
	size_t memlimit;
} UMemLimit;

static void *l_alloc_withmemlimit (void *ud, void *ptr, size_t osize, size_t nsize) {
	UMemLimit *umem = (UMemLimit *)ud;
	printf("Try use new alloc: %016p, %d, %d, %d\n", ptr, osize, nsize, umem->bytecount);

	size_t newcount;
	if (ptr == NULL){
		newcount = umem->bytecount + nsize;
	}
	else{
		if (umem->bytecount + nsize >= osize)
			newcount = umem->bytecount + nsize - osize;
		else
			newcount = 0;
	}

	if (newcount > umem->memlimit){
		printf("Alloc exceed limit\n");
		printf("newsize: %d + current: %d > limit: %d, \n", newcount, umem->bytecount, umem->memlimit);
		return NULL;
	}
	else{
		umem->bytecount = newcount;
		return umem->frealloc(umem->ud, ptr, osize, nsize);
	}
}

static void setlimit(lua_State *L, size_t memlimit){
	UMemLimit *umem = (UMemLimit *)lua_newuserdata(L, sizeof(UMemLimit));
	umem->frealloc = lua_getallocf(L, &(umem->ud));
	umem->bytecount = 0;
	umem->memlimit = memlimit;
	lua_setallocf(L, l_alloc_withmemlimit, umem);
}

int main(void) {
	lua_State *L = luaL_newstate();
	setlimit(L, 1<<16);

	char buff[256];
	int error;
	luaL_openlibs(L);

	lua_close(L);
	return 0;
}

//*/
