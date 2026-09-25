#ifndef JSONPARSER_H
#define JSONPARSER_H

typedef struct Tile{
  char image[100];
  float width;
  float height;
}Tile;

//I Just Give Up and Add Max Fix Size For TileMap or Grid.
#define MAX_SIZE 60

typedef struct TileMap{
  int twodimArray[MAX_SIZE][MAX_SIZE];
}TileMap;

int ParsingImage(char filePath[], int bufferSize, Tile *tileAtlas, TileMap *grid);

//Only Run The GetMatrixSize() after the ParsingImage().
int GetMatrixSize();

#endif
