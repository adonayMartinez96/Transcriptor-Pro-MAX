@echo off
SETLOCAL

:: ----------------------------------------------------------------------------
:: Script de instalación de FFmpeg para Windows con validaciones completas
:: ----------------------------------------------------------------------------

echo.
echo [INSTALACIÓN FFMPEG] Iniciando proceso...
echo.

:: 1. Verificar si FFmpeg ya está instalado y accesible
echo [VALIDACIÓN] Verificando si FFmpeg está en el PATH...
ffmpeg -version > nul 2>&1
if %errorlevel% equ 0 (
    echo [✔] FFmpeg ya está instalado y accesible desde el PATH.
    goto :EOF
)

:: 2. Crear carpeta de instalación si no existe
set "INSTALL_DIR=%~dp0ffmpeg"  %:: Ruta relativa al directorio del script
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

:: 3. Descargar FFmpeg (última versión para Windows)
echo [DESCARGA] Obteniendo FFmpeg desde GitHub...
set "FFMPEG_URL=https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
set "ZIP_FILE=%INSTALL_DIR%\ffmpeg.zip"

powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%FFMPEG_URL%' -OutFile '%ZIP_FILE%'" || (
    echo [ERROR] Falló la descarga de FFmpeg. Verifica tu conexión a internet.
    pause
    exit /b 1
)

:: 4. Extraer archivos
echo [EXTRACCIÓN] Descomprimiendo FFmpeg...
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%INSTALL_DIR%' -Force" || (
    echo [ERROR] No se pudo extraer el archivo ZIP.
    pause
    exit /b 1
)

:: 5. Agregar al PATH del sistema
echo [CONFIGURACIÓN] Agregando FFmpeg al PATH...
set "BIN_PATH=%INSTALL_DIR%\bin"

:: Verificar si ya está en el PATH
echo %PATH% | find /i "%BIN_PATH%" > nul
if %errorlevel% equ 0 (
    echo [✔] La ruta ya está en el PATH.
) else (
    :: Agregar al PATH permanentemente
    setx PATH "%PATH%;%BIN_PATH%" /M > nul 2>&1
    if %errorlevel% neq 0 (
        echo [ADVERTENCIA] No se pudo agregar al PATH global (ejecuta como Administrador).
        echo [SOLUCIÓN] Usando PATH temporal para esta sesión...
        set PATH=%PATH%;%BIN_PATH%
    ) else (
        echo [✔] Ruta agregada al PATH correctamente.
    )
)

:: 6. Validación final
echo.
echo [VALIDACIÓN] Comprobando instalación...
ffmpeg -version > nul 2>&1
if %errorlevel% equ 0 (
    echo [✔] FFmpeg instalado correctamente.
    echo [INFO] Versión instalada:
    ffmpeg -version | findstr /i "version"
) else (
    echo [ERROR] La instalación falló en la última validación.
    echo [SOLUCIÓN] Ejecuta este script como Administrador o reinstala manualmente.
    pause
    exit /b 1
)

:: 7. Limpieza (opcional)
del "%ZIP_FILE%" > nul 2>&1
echo.
echo [✔] Proceso completado. Reinicia tus terminales para aplicar cambios en el PATH.
pause
