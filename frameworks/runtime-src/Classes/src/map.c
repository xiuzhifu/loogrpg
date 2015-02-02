#include "map.h"
#include <stdio.h>
int
	map_load(struct map *m, const char* filename){
	FILE * f = fopen(filename, "r");
	if (f == NULL) return -1;
	fread(&m->header, sizeof(struct map_header), 1, f);
	if ((m->header.flag[0] != '.') | (m->header.flag[1] != 'A') | (m->header.flag[2] != 'B') | (m->header.flag[3] != 'C')) return -2;
	if (m->header.picture_count > 0){
		//m->pictures = new struct map_picture[m->header.picture_count];
		m->pictures = (struct map_picture *)malloc((unsigned long)sizeof(struct map_picture) * m->header.picture_count);
		fread(m->pictures, sizeof(struct map_picture), m->header.picture_count, f);
	};

	if (m->header.animation_count > 0){
		//m->animations = new struct map_animation[m->header.animation_count];
		m->animations = (struct map_animation *)malloc(sizeof(struct map_animation) * m->header.animation_count);
		fread(m->animations, sizeof(struct map_animation), m->header.animation_count, f);
	};
	//m->flags = new int16_t[m->header.width * m->header.height];
	m->flags = (int16_t *)malloc(sizeof(int16_t) * m->header.width * m->header.height);
	fread(m->flags, sizeof(int16_t), m->header.width * m->header.height, f);  

	return 1;
}

int
	map_flag(struct map *m, const uint16_t x, const uint16_t y, const uint16_t flag){
	return (*(m->flags + y * m->header.width + x) & flag) == 0 ? 1 : 0;
}