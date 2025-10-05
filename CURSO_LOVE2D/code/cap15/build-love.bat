@echo off
setlocal

:: Configurações
set "GAME_NAME=meu_jogo"
set "VERSION=1.0.0"
set "BUILD_DIR=builds"
set "LOVE_FILE=%BUILD_DIR%\%GAME_NAME%-v%VERSION%.love"
set "ZIP=C:\Program Files\7-Zip\7z.exe"

:: Verificar se o 7-Zip existe
if not exist "%ZIP%" (
    echo Erro: 7-Zip não encontrado em "%ZIP%"
    exit /b
)

:: Criar diretório de builds
if not exist "%BUILD_DIR%" (
    mkdir "%BUILD_DIR%"
)

:: Remover versões anteriores
echo Removendo versões anteriores:
dir /b "%BUILD_DIR%\%GAME_NAME%-v*.love" 2>nul
del /F /Q "%BUILD_DIR%\%GAME_NAME%-v*.love"

:: Criar arquivo .love
echo Criando arquivo .love...
"%ZIP%" a -tzip "%LOVE_FILE%" * -x!"%BUILD_DIR%\" -x!".git\" -x!"*.DS_Store" -x!"*.Thumbs.db" -x!"*.md" -x!"*.bat" -x!"*.sh" -x!"**\*.tmx" -x!"*.ps1"

echo Arquivo .love criado: %LOVE_FILE%

:: Testar o jogo se o LÖVE estiver instalado
where love >nul 2>nul
if %errorlevel%==0 (
    echo Testando arquivo .love...
    love "%LOVE_FILE%"
) else (
    echo LÖVE não está instalado ou não está no PATH.
)

endlocal
