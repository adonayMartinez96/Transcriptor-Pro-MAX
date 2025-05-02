@echo off
SETLOCAL

:: -----------------------------------------------------------------
:: INSTALADOR ROBUSTO DE FFMPEG CON MANEJO DE ERRORES MEJORADO
:: -----------------------------------------------------------------

echo.
echo [INSTALADOR FFMPEG] Iniciando instalación...
echo.

:: 1. Configuración de rutas
set "INSTALL_DIR=%~dp0ffmpeg"
set "BIN_DIR=%INSTALL_DIR%\bin"
set "FFMPEG_PATH=%BIN_DIR%\ffmpeg.exe"
set "ZIP_FILE=%INSTALL_DIR%\ffmpeg.zip"
set "DOWNLOAD_URL=https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"

:: 2. Verificación inicial mejorada
if exist "%FFMPEG_PATH%" (
    "%FFMPEG_PATH%" -version >nul 2>&1
    if %errorlevel% equ 0 (
        echo [✔] FFmpeg ya está instalado correctamente en:
        echo     "%FFMPEG_PATH%"
        goto :EnsurePath
    ) else (
        echo [⚠] Archivo ffmpeg.exe encontrado pero no funciona, reinstalando...
        rmdir /s /q "%INSTALL_DIR%" 2>nul
    )
)

:: 3. Crear estructura de directorios
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

:: 4. Descarga con reintentos y verificación
echo [📥] Descargando FFmpeg...
set "DOWNLOAD_SUCCESS=false"
for %%i in (1,2,3) do (
    if "%DOWNLOAD_SUCCESS%"=="false" (
        powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest '%DOWNLOAD_URL%' -OutFile '%ZIP_FILE%'"
        if exist "%ZIP_FILE%" (
            set "DOWNLOAD_SUCCESS=true"
        ) else (
            echo [⚠] Intento %%i/3 fallido, reintentando...
            timeout /t 3 >nul
        )
    )
)

if "%DOWNLOAD_SUCCESS%"=="false" (
    echo [❌] Error: No se pudo descargar FFmpeg después de 3 intentos
    echo       Verifique su conexión a internet o la URL:
    echo       %DOWNLOAD_URL%
    pause
    exit /b 1
)

:: 5. Extracción robusta
echo [📦] Extrayendo archivos...
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%INSTALL_DIR%' -Force"
del "%ZIP_FILE%" >nul 2>&1

:: 6. Verificación mejorada de instalación
if not exist "%FFMPEG_PATH%" (
    echo [❌] Error crítico: No se encontró ffmpeg.exe después de la instalación
    echo.
    echo [🔍] Diagnóstico avanzado:
    echo.
    echo Contenido del directorio de instalación:
    dir "%INSTALL_DIR%" /s /b
    
    echo.
    echo Posibles soluciones:
    echo 1. Ejecutar como Administrador
    echo 2. Desactivar temporalmente el antivirus
    echo 3. Descargar manualmente desde:
    echo    %DOWNLOAD_URL%
    echo    y extraer en: %INSTALL_DIR%
    
    pause
    exit /b 1
)

:: 7. Verificar que el binario sea funcional
"%FFMPEG_PATH%" -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [❌] Error: FFmpeg no funciona correctamente
    echo       El archivo existe pero no se ejecuta
    echo       Posible archivo corrupto o incompleto
    pause
    exit /b 1
)

:EnsurePath
:: 8. Configuración del PATH
echo %PATH% | find /i "%BIN_DIR%" >nul
if %errorlevel% neq 0 (
    echo [⚙] Configurando PATH del sistema...
    setx PATH "%PATH%;%BIN_DIR%" /M >nul 2>&1
    if %errorlevel% equ 0 (
        echo [✔] PATH actualizado correctamente
    ) else (
        echo [⚠] No se pudo modificar el PATH global
        echo     Ejecute el script como Administrador para acceso completo
        echo     Usando PATH temporal para esta sesión...
        set PATH=%PATH%;%BIN_DIR%
    )
)

echo.
echo [✔✔✔] INSTALACIÓN COMPLETADA CON ÉXITO
echo     FFmpeg está listo para ser usado
echo.
pause