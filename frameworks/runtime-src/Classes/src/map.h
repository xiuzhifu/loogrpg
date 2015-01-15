#ifndef MAP_H
#define MAP_H
//#pragma pack(2)
#include<stdint.h>
/*单层地图实现，遮挡关系都做半透明处理*/
struct map_header {
	char flag[4];//.ABC
	uint16_t width;
	uint16_t height;
	uint16_t picture_count;
	uint16_t animation_count;
};

struct map_picture {
	uint32_t x;//x坐标(像素)
	uint32_t y;//y坐标(像素)
	uint16_t pictureid;
};

struct map_animation {
	uint16_t x;
	uint16_t y;
	uint16_t animation;//动画id
	int8_t animation_offsetx;//动画基于当前格子x方向偏移量
	int8_t animation_offsety;//动画基于当前格子y方向偏移量
};

#define FLAG_MOVE 0x0001
#define FLAG_FLY 0x0002
#define FLAG_BLEND 0x0004
#define FLAG_PICTURE 0x0008
#define FLAG_ANIMATION 0x0010

struct map_cellflag {
	/*
	1 不可行走
	2 不可飞行
	3 遮挡点
	4 图片
	5 有动画
	*/
	int16_t flag;
};

struct map {
	struct  map_header header;
	struct map_picture *pictures;
	struct map_animation *animations;
	int16_t *flags;
};
int map_load(struct map *m, const char* filename);
int map_flag(struct map *m, const uint16_t x, const uint16_t y, const uint16_t flag);

#endif

