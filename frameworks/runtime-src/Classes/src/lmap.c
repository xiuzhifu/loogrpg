

#include "map.h"
struct map * MAP = NULL;
#if __cplusplus
extern "C"{
#endif
#include <lua.h>
#include <lauxlib.h>
int 
lmap_new(lua_State *L){
	MAP = (struct  map *)malloc(sizeof(struct map));
	return 0;
}

int
lmap_free(lua_State *L){
	free(MAP);
	return 0;
}

int 
lmap_load(lua_State *L){
	const char* filename = luaL_checkstring(L, 1);
	lua_pushboolean(L, map_load(MAP, filename));
	return 1;
}

int 
lmap_canmove(lua_State *L){
	const uint16_t x = lua_tointeger(L, 1);
	const uint16_t y = lua_tointeger(L, 2);
	lua_pushboolean(L, map_canmove(MAP, x, y));
	return 1;
}

int 
lmap_getpicture(lua_State *L){
	lua_newtable(L);
	for (int i = 0; i < MAP->header.picture_count; i++){
		struct map_picture *picture = MAP->pictures + i;
		lua_newtable(L);

		lua_pushliteral(L, "x");
		lua_pushinteger(L, picture->x);
		lua_rawset(L, -4);

		lua_pushliteral(L, "y");
		lua_pushinteger(L, picture->y);
		lua_rawset(L, -4);

		lua_pushliteral(L, "picture");
		lua_pushinteger(L, picture->pictureid);
		lua_rawset(L, -4);

		lua_rawseti(L, -2, 1);
	}
	return 1;
}

int 
lmap_getanimation(lua_State *L){
	lua_newtable(L);
	for (int i = 0; i < MAP->header.picture_count; i++){
		struct map_animation *animation = MAP->animations + i;
		lua_newtable(L);

		lua_pushliteral(L, "x");
		lua_pushinteger(L, animation->x);
		lua_rawset(L, -4);

		lua_pushliteral(L, "y");
		lua_pushinteger(L, animation->y);
		lua_rawset(L, -4);

		lua_pushliteral(L, "offsetx");
		lua_pushinteger(L, animation->animation_offsetx);
		lua_rawset(L, -4);

		lua_pushliteral(L, "offsety");
		lua_pushinteger(L, animation->animation_offsety);
		lua_rawset(L, -4);

		lua_pushliteral(L, "animation");
		lua_pushinteger(L, animation->animation);
		lua_rawset(L, -4);

		lua_rawseti(L, -2, 1);
	}
	return 1;
}

int open_map(lua_State *L){
	luaL_Reg l[] = {
		{ "new", lmap_new},
		{ "free", lmap_free},
		{ "load", lmap_load },	
		{ "getpictures", lmap_getpicture },
		{ "getanimations", lmap_getanimation },  
		{ NULL, NULL },
	};
	luaL_openlib(L, "map2", l, 0);
	return 1;
}
#if __cplusplus 
} // extern "C"
#endif


