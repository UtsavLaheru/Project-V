call C:\raylib\emsdk\emsdk_env.bat
cmake --build build-web
if %errorlevel% neq 0 exit /b
cd build-web\raylib-game-template
emrun raylib-game-template.html