@echo off

::Checks File
if "%~1"=="" (
    echo Usage: run filename.c
    exit /b
)

set "OUT=%~n1"

::main command
gcc "%~1" test_scripts/jsonparser.c ^
cJSON/cJSON.c ^
-IcJSON ^
-Ibuild\_deps\raylib-src\src ^
-Lbuild\_deps\raylib-build\raylib ^
-lraylib ^
-lopengl32 ^
-lgdi32 ^
-lwinmm ^
-o "test_outputs\%OUT%.exe"

if %errorlevel% neq 0 exit /b

"test_outputs\%OUT%.exe"

:: Remeber to put spaces After the "^" or it will be
:: Printed like cJSON.c-IcJSON which the gcc doesn't like. 
