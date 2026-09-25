#include <stdio.h>
#include "cJSON.h"
#include <stdlib.h>
#include "jsonparser.h"

int sizeOfMatrix;    //This is a Square Matrix.
// int convertedToArray[][];

int GetMatrixSize()
{
   return sizeOfMatrix;
}

int ParsingImage(char filePath[], int bufferSize, Tile *tileAtlas, TileMap *grid)
{
   FILE *fp = fopen(filePath,"rb");
   if(fp == NULL)
   {
        printf("Unable To fetch json file\n");
        exit(1);
   }
   //reading the file into string, We can use Malloc for buffer size
   char buffer[bufferSize];                       //1024 bytes it about 1kb Previous 5120.
   int len = fread(buffer, 1, sizeof(buffer), fp);
   buffer[len-1] = '\0';    
   //Check that how much do data we need to read or readen.
   // printf("%s\n", buffer);
   fclose(fp);

   cJSON *json = cJSON_Parse(buffer);
   // printf("%s\n", cJSON_Print(json));
   if (json == NULL)
   {
       printf("Json Object Not Loaded OR NULL");
       printf("%s\n",cJSON_GetErrorPtr());
       cJSON_Delete(json);
       exit(1);
   }
   
   cJSON *name = cJSON_GetObjectItem(json, "layers");
   cJSON *id = cJSON_GetObjectItem(name->child, "id");     //A Way To Find id Field Inside Layer in cJSON
   printf("name:%s\n", cJSON_Print(id)); 

   cJSON *tilesets = cJSON_GetObjectItem(json, "tilesets");
   cJSON *source = cJSON_GetObjectItem(tilesets->child, "source");
   printf("source:%s\n", cJSON_Print(source));

   //Tile Placement Array
   cJSON *data = cJSON_GetObjectItem(name->child, "data");
   // printf("data:%s\n", cJSON_Print(data));
   int sizeOfData = cJSON_GetArraySize(data);
   //This For Loop is For Finding Array of 23x23 or multiple of which
   for(int i=1;i<=sizeOfData/2;i++)
   {
       if(sizeOfData/i == i)
       {
           printf("it a Array of %d\n", i);
           sizeOfMatrix = i;
           break;
       }
   }
   // int convertedToArray[sizeOfMatrix][sizeOfMatrix];
   // int singleDimConvertedArray[sizeOfData];
   int tmp = 0;

   //Converting JSON into Array using cJSON
   for(int y=0;y<sizeOfMatrix;y++)      //Rows (Downward)
   {
      for(int x=0;x<sizeOfMatrix;x++)          //Columns (Rightward)
      {
         // printf("%d\n", tmp);
         grid->twodimArray[y][x] = (int)cJSON_GetArrayItem(data,tmp)->valuedouble;
         printf("%d ", grid->twodimArray[y][x]);
         tmp++;
      }
      printf("\n");
   }
   
   char Path[] = ".\\src\\resources\\Tiles\\";
   char *tilePath = source->valuestring; 
   printf("%s\n",tilePath);
   char TotaltilePath[100];
   sprintf(TotaltilePath,"%s%s",Path,tilePath);
   // printf("%s\n", TotaltilePath);
   FILE *tiles = fopen(TotaltilePath,"rb");
   if (tiles == NULL)
   {
      printf("Unable to Fetch Tiles json\n");
      exit(1);
   }

   char buffer2[4100];
   int len2 = fread(buffer2, 1, sizeof(buffer2), tiles);
   buffer2[len2-1] = '\0';
   // printf("Tiles File:\n%s", buffer2);
   fclose(tiles);
   
   //Prasing and Adding cJSON OBJCT To Parse the Buffer2
   cJSON *tilesjson = cJSON_Parse(buffer2);
   if (tilesjson == NULL)
   {
      printf("Unable To Prase Tiles cJSON Object or is Empty");
      printf("%s\n", cJSON_GetErrorPtr());
      cJSON_Delete(tilesjson);
      exit(1);
   }
   cJSON *image = cJSON_GetObjectItem(tilesjson, "image");
   printf("image:%s\n", image->valuestring);

   cJSON *widthOfWoodenTile = cJSON_GetObjectItem(tilesjson, "tilewidth");
   cJSON *heightOfWoodenTile = cJSON_GetObjectItem(tilesjson, "tileheight");
   // printf("widthOfimage:%lf\n", widthOfWoodenTile->valuedouble);    //Displays the JSON value in double using cJSON 
   tileAtlas->height = (float)widthOfWoodenTile->valuedouble;     
   tileAtlas->width = (float)heightOfWoodenTile->valuedouble;     
   // printf("Wooden Floor Tileset Height:%f, Width:%f\n", tileAtlas->height, tileAtlas->width);
   
   // Passing Objects To Variables
   char Path2[] = ".\\src\\resources\\Tiles\\";
   char *imagePath = image->valuestring;
   sprintf(tileAtlas->image, "%s%s", Path2, imagePath);
   printf("%s\n",tileAtlas->image);
   
   cJSON_Delete(tilesjson);
   cJSON_Delete(json);
   return 0;
}

