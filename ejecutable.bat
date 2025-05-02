@echo off
SETLOCAL
title Instalador Completo - FFmpeg y Dependencias Python
mode con: cols=100 lines=30
color 0A

:: ==============================================
:: CONFIGURACIÓN INICIAL
:: ==============================================
set "LOG_FILE=install_log.txt"
echo [%date% %time%] Inicio de instalación > %LOG_FILE%
echo [INSTALADOR COMPLETO] Iniciando proceso...
echo.

:: ==============================================
:: INSTALACIÓN DE FFMPEG (VERSIÓN MEJORADA)
:: ==============================================
set "FFMPEG_DIR=%~dp0ffmpeg"
set "FFMPEG_EXE=%FFMPEG_DIR%\ffmpeg-master-latest-win64-gpl\bin\ffmpeg.exe"
set "FFMPEG_BIN=%FFMPEG_DIR%\ffmpeg-master-latest-win64-gpl\bin"
set "FFMPEG_ZIP=%FFMPEG_DIR%\ffmpeg.zip"
set "FFMPEG_URL=https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"

:: Verificar si FFmpeg ya está instalado
if exist "%FFMPEG_EXE%" (
    echo [✔] FFmpeg ya está instalado en: >> %LOG_FILE%
    echo %FFMPEG_EXE% >> %LOG_FILE%
    echo [✔] FFmpeg ya está instalado:
    echo     "%FFMPEG_EXE%"
    goto :CheckPythonDeps
)

:: Instalación de FFmpeg
echo [📥] Descargando FFmpeg... >> %LOG_FILE%
if not exist "%FFMPEG_DIR%" mkdir "%FFMPEG_DIR%"
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = 'Tls12'; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest '%FFMPEG_URL%' -OutFile '%FFMPEG_ZIP%'"
if not exist "%FFMPEG_ZIP%" (
    echo [❌] Error en la descarga de FFmpeg >> %LOG_FILE%
    echo [❌] Error: No se pudo descargar FFmpeg
    pause
    exit /b 1
)

echo [📦] Extrayendo FFmpeg... >> %LOG_FILE%
powershell -Command "Expand-Archive -Path '%FFMPEG_ZIP%' -DestinationPath '%FFMPEG_DIR%' -Force"
del "%FFMPEG_ZIP%"

if not exist "%FFMPEG_EXE%" (
    echo [❌] Error: No se encontró ffmpeg.exe >> %LOG_FILE%
    echo [❌] Error crítico: Archivo ffmpeg.exe no encontrado después de la instalación
    pause
    exit /b 1
)

:: Configurar PATH para FFmpeg
echo [⚙] Configurando PATH para FFmpeg... >> %LOG_FILE%
setx PATH "%PATH%;%FFMPEG_BIN%" /M >nul 2>&1
if %errorlevel% neq 0 (
    echo [⚠] No se pudo modificar el PATH global >> %LOG_FILE%
    set PATH=%PATH%;%FFMPEG_BIN%
)

echo [✔] FFmpeg instalado correctamente >> %LOG_FILE%
echo [✔] FFmpeg instalado correctamente en:
echo     "%FFMPEG_EXE%"

:: ==============================================
:: INSTALACIÓN DE DEPENDENCIAS PYTHON
:: ==============================================
:CheckPythonDeps
echo [INFO] Verificando dependencias Python... >> %LOG_FILE%

:: Verificar si pip está instalado
python -m pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [❌] Error: pip no está instalado o Python no está configurado >> %LOG_FILE%
    echo [❌] Error: pip no está disponible. Verifique la instalación de Python
    pause
    exit /b 1
)

:: Verificar Whisper
pip show whisper >nul 2>&1
if %errorlevel% equ 0 (
    echo [✔] Whisper ya está instalado >> %LOG_FILE%
    echo [✔] Whisper ya está instalado
    goto :StartApp
)

:: Instalar dependencias
echo [INSTALACIÓN] Instalando dependencias Python... >> %LOG_FILE%
echo [INSTALACIÓN] Actualizando pip...
pip install --upgrade pip || (
    echo [ERROR] Falló la actualización de pip >> %LOG_FILE%
    echo [ERROR] Falló la actualización de pip
    pause
    exit /b 1
)

echo [INSTALACIÓN] Instalando dependencias del requirements.txt...
if exist "requirements.txt" (
    pip install -r requirements.txt --force-reinstall || (
        echo [ERROR] Falló la instalación de dependencias >> %LOG_FILE%
        echo [ERROR] Falló la instalación de dependencias
        pause
        exit /b 1
    )
) else (
    echo [ℹ] No se encontró requirements.txt, instalando whisper directamente >> %LOG_FILE%
    pip install whisper --force-reinstall || (
        echo [ERROR] Falló la instalación de whisper >> %LOG_FILE%
        echo [ERROR] Falló la instalación de whisper
        pause
        exit /b 1
    )
)

:: Verificar instalación de Whisper
python -c "import whisper; print('Whisper instalado correctamente')" || (
    echo [ERROR] Falló la verificación de Whisper >> %LOG_FILE%
    echo [ERROR] Falló la verificación de Whisper
    pause
    exit /b 1
)

echo [✔] Dependencias Python instaladas correctamente >> %LOG_FILE%
echo [✔] Dependencias Python instaladas correctamente

:: ==============================================
:: INICIAR LA APLICACIÓN
:: ==============================================
:StartApp
echo.
echo [✔✔✔] TODAS LAS DEPENDENCIAS INSTALADAS CON ÉXITO
echo [INFO] Iniciando la aplicación...
echo [APP] Iniciando app.py >> %LOG_FILE%
python app.py || (
    echo [ERROR] No se pudo iniciar app.py >> %LOG_FILE%
    echo [ERROR] No se pudo iniciar la aplicación
    pause
    exit /b 1
)

:: ==============================================
:: FINALIZACIÓN
:: ==============================================
echo.
echo Instalación completada. Puede cerrar esta ventana.
echo Revise %LOG_FILE% para detalles técnicos.
pause