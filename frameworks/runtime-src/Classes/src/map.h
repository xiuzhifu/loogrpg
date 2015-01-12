#ifndef MAP_H
#define MAP_H
#include<stdint.h>
#pragma pack(2)
/*�����ͼʵ�֣��ڵ���ϵ������͸������*/
struct map_header {
	char header[32];
	uint16_t width;
	uint16_t height;
	uint16_t picture_count;
	uint16_t animation_count;
};

struct map_picture {
	uint16_t x;
	uint16_t y;
	uint16_t pictureid;
};

struct map_animation {
	uint16_t x;
	uint16_t y;
	uint16_t animation;//����id
	int8_t animation_offsetx;//�������ڵ�ǰ����x����ƫ����
	int8_t animation_offsety;//�������ڵ�ǰ����y����ƫ����
};

struct map_cellflag {
	/*
	1 ��������
	2 ���ɷ���
	2 �ڵ���
	*/
	int16_t flag;
};

struct map {
	struct  map_header header;
	struct map_picture *pictures;
	struct map_animation *animations;
	int16_t *flags;
};
bool map_load(struct map *map, const char* filename);

bool map_canmove(struct map *map, const uint16_t x, const uint16_t y);

bool map_canfly(struct map *map, const uint16_t x, const uint16_t y);

bool map_blend(struct map *map, const uint16_t x, const uint16_t y);
#endif

