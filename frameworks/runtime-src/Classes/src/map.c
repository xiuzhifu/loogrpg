#include "map.h"
#include <stdio.h>
int
map_load(struct map *map, const char* filename){
    FILE * f = fopen(filename, "r");
    if (f == NULL) return -1;
    fread(&map->header, sizeof(struct map_header), 1, f);
    if (map->header.flag[0] != 'L' | map->header.flag[1] != 'Z' | map->header.flag[2] != 'L' ) return -2;
    if (map->header.picture_count > 0){
        
        map->pictures = (struct map_picture *)malloc((unsigned long)sizeof(struct map_picture) * map->header.picture_count);
        fread(map->pictures, sizeof(struct map_picture), map->header.picture_count, f);
    };
    
    if (map->header.animation_count > 0){
        
        map->animations = (struct map_animation *)malloc(sizeof(struct map_animation) * map->header.animation_count);
        fread(map->animations, sizeof(struct map_animation), map->header.animation_count, f);
    };
    
    map->flags = (int16_t)malloc(sizeof(int16_t) * map->header.width * map->header.height);
    
    
		
	return 0;
}

int
map_canmove(struct map *map, const uint16_t x, const uint16_t y){
    return (*(map->flags + y * map->header.width + x) & 0x01) == 0 ? 1: 0;
}

int
map_canflay(struct map *map, const uint16_t x, const uint16_t y){
	return (*(map->flags + y * map->header.width + x) & 0x02) == 0 ? 1: 0;
}

int
map_blend(struct map *map, const uint16_t x, const uint16_t y){
	return (*(map->flags + y * map->header.width + x) & 0x03) == 0 ? 1: 0;
}
