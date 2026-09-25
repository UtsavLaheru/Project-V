#include "raylib.h"
#include <stdio.h>

int main()
{
  const int ScreenWidth = 740;
  const int ScreenHeight = 620;

  InitWindow(ScreenWidth, ScreenHeight, "Testing Scene For Project P");

  while (!WindowShouldClose()) {
    BeginDrawing();
      ClearBackground(RAYWHITE);
    EndDrawing();
  }
  return 0; 
}
