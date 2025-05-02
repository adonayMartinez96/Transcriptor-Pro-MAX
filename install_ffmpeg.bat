@echo off
SETLOCAL

:: -----------------------------------------------------------------
:: Instalador de FFmpeg para Whisper Transcriber Pro - Versión Mejorada
:: -----------------------------------------------------------------

echo.
echo [INSTALADOR FFMPEG] Iniciando proceso de instalación...
echo.

:: 1. Verificación inteligente de FFmpeg existente
set "FFMPEG_PATH=%CD%\ffmpeg\bin\ffmpeg.exe"

:: Verificar si ya está instalado localmente y funciona
if exist "%FFMPEG_PATH%" (
    "%FFMPEG_PATH%" -version >nul 2>&1
    if %errorlevel% equ 0 (
        echo [✔] FFmpeg ya está instalado y funciona en:
        echo       %FFMPEG_PATH%
        goto :EnsurePath
    )
)

:: 2. Descarga e instalación
echo [📥] Descargando FFmpeg...
set "DOWNLOAD_URL=https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
set "ZIP_FILE=%TEMP%\ffmpeg.zip"

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest '%DOWNLOAD_URL%' -OutFile '%ZIP_FILE%'"

if not exist "%ZIP_FILE%" (
    echo [❌] Error: No se pudo descargar FFmpeg
    pause
    exit /b 1
)

echo [📦] Extrayendo archivos...
if exist "%CD%\ffmpeg" rmdir /s /q "%CD%\ffmpeg"
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%CD%\ffmpeg' -Force"
del "%ZIP_FILE%"

:: 3. Verificación de instalación
if not exist "%FFMPEG_PATH%" (
    echo [❌] Error crítico: No se encontró ffmpeg.exe después de la instalación
    pause
    exit /b 1
)

:EnsurePath
:: 4. Agregar al PATH del sistema (solo si no está)
echo %PATH% | find /i "%CD%\ffmpeg\bin" >nul
if %errorlevel% neq 0 (
    echo [⚙] Agregando a PATH del sistema...
    setx PATH "%PATH%;%CD%\ffmpeg\bin" /M >nul 2>&1
    if %errorlevel% neq 0 (
        echo [⚠] No se pudo modificar el PATH global (ejecuta como Admin)
        echo [ℹ] Usando PATH temporal para esta sesión...
        set PATH=%PATH%;%CD%\ffmpeg\bin
    )
)

:: 5. Prueba final
echo [🔍] Verificando instalación...
"%FFMPEG_PATH%" -version >nul 2>&1
if %errorlevel% equ 0 (
    echo.
    echo [✔✔✔] INSTALACIÓN COMPLETADA CON ÉXITO
    echo       FFmpeg está listo para ser usado por Whisper Transcriber Pro
    echo.
    echo [ℹ] Puedes ejecutar ahora tu aplicación normalmente
) else (
    echo [❌] Error: La instalación no pasó la verificación final
)

pause