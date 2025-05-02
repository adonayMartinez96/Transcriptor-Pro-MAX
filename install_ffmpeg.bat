@echo off
SETLOCAL

:: ----------------------------------------------------------------
:: INSTALADOR DE FFMPEG CON MANEJO DE NUEVA ESTRUCTURA DE CARPETAS
:: ----------------------------------------------------------------

echo.
echo [INSTALACIÓN FFMPEG] Iniciando proceso...
echo.

:: 1. Configurar rutas
set "INSTALL_DIR=%~dp0ffmpeg"
set "FFMPEG_EXE=%INSTALL_DIR%\ffmpeg-master-latest-win64-gpl\bin\ffmpeg.exe"
set "NEW_LOCATION=%INSTALL_DIR%\ffmpeg-master-latest-win64-gpl"
set "ZIP_FILE=%INSTALL_DIR%\ffmpeg.zip"
set "DOWNLOAD_URL=https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"

:: 2. Verificar si ya está instalado correctamente
if exist "%FFMPEG_EXE%" (
    echo [✔] FFmpeg ya está instalado en:
    echo     "%FFMPEG_EXE%"
    goto :EnsurePath
)

:: 3. Crear directorio de instalación
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: 4. Descargar FFmpeg
echo [📥] Descargando FFmpeg...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest '%DOWNLOAD_URL%' -OutFile '%ZIP_FILE%'"
if not exist "%ZIP_FILE%" (
    echo [❌] Error en la descarga
    pause
    exit /b 1
)

:: 5. Extraer archivos
echo [📦] Extrayendo FFmpeg...
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%INSTALL_DIR%' -Force"
del "%ZIP_FILE%"

:: 6. Verificar nueva estructura de carpetas
if not exist "%FFMPEG_EXE%" (
    echo [❌] Error: No se encontró ffmpeg.exe en la ubicación esperada
    echo.
    echo [🔍] Estructura de carpetas encontrada:
    dir "%NEW_LOCATION%" /s /b
    
    echo.
    echo [ℹ] La estructura del ZIP ha cambiado. Se ajustará automáticamente...
    
    :: Mover los archivos a la ubicación esperada
    if exist "%NEW_LOCATION%\bin\ffmpeg.exe" (
        xcopy "%NEW_LOCATION%\bin" "%INSTALL_DIR%\bin\" /s /e /y
        rmdir /s /q "%NEW_LOCATION%"
        set "FFMPEG_EXE=%INSTALL_DIR%\bin\ffmpeg.exe"
    ) else (
        echo [❌] No se pudo encontrar ffmpeg.exe en ninguna ubicación
        pause
        exit /b 1
    )
)

:: 7. Verificar instalación final
if exist "%FFMPEG_EXE%" (
    echo [✔] FFmpeg instalado correctamente en:
    echo     "%FFMPEG_EXE%"
) else (
    echo [❌] Error crítico: No se pudo instalar FFmpeg
    pause
    exit /b 1
)

:EnsurePath
:: 8. Configurar PATH del sistema
set "BIN_DIR=%~dp0ffmpeg\bin"
echo %PATH% | find /i "%BIN_DIR%" >nul
if %errorlevel% neq 0 (
    echo [⚙] Configurando PATH del sistema...
    setx PATH "%PATH%;%BIN_DIR%" /M >nul 2>&1
    if %errorlevel% equ 0 (
        echo [✔] PATH actualizado correctamente
    ) else (
        echo [⚠] No se pudo modificar el PATH global
        echo     Ejecute como Administrador para acceso completo
        echo     Usando PATH temporal para esta sesión...
        set PATH=%PATH%;%BIN_DIR%
    )
)

echo.
echo [✔✔✔] INSTALACIÓN COMPLETADA CON ÉXITO
echo     FFmpeg está listo para ser usado
echo.
pause