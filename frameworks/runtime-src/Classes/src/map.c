#include "map.h"
bool
	map_load(struct map *map, const char* filename){
	return true;
}

bool
	map_canmove(struct map *map, const uint16_t x, const uint16_t y){
	return *(map->flags + y * map->header.width + x) & 0x01 == 0;
}

bool
	map_canflay(struct map *map, const uint16_t x, const uint16_t y){
	return *(map->flags + y * map->header.width + x) & 0x02 == 0;
}

bool
	map_blend(struct map *map, const uint16_t x, const uint16_t y){
	return *(map->flags + y * map->header.width + x) & 0x03 == 0;
}
