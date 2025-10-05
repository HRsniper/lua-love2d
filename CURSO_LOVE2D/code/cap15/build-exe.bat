@echo off
set "GAME_NAME=meu_jogo"
set "VERSION=1.0.0"
set "BUILD_DIR=builds"
set "LOVE_FILE=%BUILD_DIR%\%GAME_NAME%-v%VERSION%.love"
set "LOVE_PATH=C:\Users\%USERNAME%\Desktop\love-11.5-win64"

# Criar executável
copy /b "%LOVE_PATH%\love.exe"+"%LOVE_FILE%" "%LOVE_FILE%.exe"

# Copiar DLLs necessárias
copy "%LOVE_PATH%\*.dll" "%BUILD_DIR%\"
copy "%LOVE_PATH%\license.txt" "%BUILD_DIR%\LOVE-license.txt"

echo Executável Windows criado!
