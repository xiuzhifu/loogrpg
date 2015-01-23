//#include "cocos2d.h"
#include "platform/CCFileUtils.h"
#include "map.h"
#if __cplusplus
extern "C"{
#endif
#include <lua.h>
#include <lauxlib.h>

USING_NS_CC;
static struct map * MAP = (struct  map *)malloc(sizeof(struct map));
int 
lmap_load(lua_State *L){
	const char* filename = luaL_checkstring(L, 1);
	std::string fn = FileUtils::getInstance()->fullPathForFilename(filename);
	if (fn == "") return 0;
	if (map_load(MAP, fn.c_str()) < 0) return -1;
	lua_newtable(L);
	lua_pushliteral(L, "width");
	lua_pushinteger(L, MAP->header.width);
	lua_rawset(L, -3);

	lua_pushliteral(L, "height");
	lua_pushinteger(L, MAP->header.height);
	lua_rawset(L, -3);
	return 1;
}

int 
lmap_canmove(lua_State *L){
	const uint16_t x = lua_tointeger(L, 1);
	const uint16_t y = lua_tointeger(L, 2);
	lua_pushboolean(L, map_flag(MAP, x, y, FLAG_MOVE));
	return 1;
}

int 
lmap_getpicture(lua_State *L){
	if (MAP->header.picture_count == 0) return 0;
	lua_newtable(L);
	for (int i = 0; i < MAP->header.picture_count; i++){
		struct map_picture *picture = MAP->pictures + i;
		lua_newtable(L);

		lua_pushliteral(L, "x");
		lua_pushinteger(L, picture->x);
		lua_rawset(L, -3);

		lua_pushliteral(L, "y");
		lua_pushinteger(L, picture->y);
		lua_rawset(L, -3);

		lua_pushliteral(L, "picture");
		lua_pushinteger(L, picture->pictureid);
		lua_rawset(L, -3);

		lua_rawseti(L, -2, i + 1);
	}
	return 1;
}

int 
lmap_getanimation(lua_State *L){
	if (MAP->header.animation_count == 0) return 0;
	lua_newtable(L);
	for (int i = 0; i < MAP->header.animation_count; i++){
		struct map_animation *animation = MAP->animations + i;
		lua_newtable(L);

		lua_pushliteral(L, "x");
		lua_pushinteger(L, animation->x);
		lua_rawset(L, -3);

		lua_pushliteral(L, "y");
		lua_pushinteger(L, animation->y);
		lua_rawset(L, -3);

		lua_pushliteral(L, "offsetx");
		lua_pushinteger(L, animation->animation_offsetx);
		lua_rawset(L, -3);

		lua_pushliteral(L, "offsety");
		lua_pushinteger(L, animation->animation_offsety);
		lua_rawset(L, -3);

		lua_pushliteral(L, "animation");
		lua_pushinteger(L, animation->animation);
		lua_rawset(L, -3);

		lua_rawseti(L, -2, 1);
	}
	return 1;
}

int open_map(lua_State *L){
	luaL_Reg l[] = {
		{ "load", lmap_load },	
		{ "getpictures", lmap_getpicture },
		{ "getanimations", lmap_getanimation },  
		{ NULL, NULL },
	};
	luaL_openlib(L, "map.c", l, 0);
	//luaL_newlib(L, l);
	return 1;
}
#if __cplusplus 
} // extern "C"
#endif


