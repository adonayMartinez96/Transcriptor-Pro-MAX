@echo off
SETLOCAL

:: Función para verificar si FFmpeg está instalado
:CheckFFmpeg
ffmpeg -version > nul 2>&1
if %errorlevel% equ 0 (
    echo [✔] FFmpeg ya está instalado.
    goto :CheckPythonDeps
) else (
    echo [INSTALACIÓN] FFmpeg no encontrado. Instalando...
    goto :InstallFFmpeg
)

:: 1. Instalar FFmpeg si no está instalado
:InstallFFmpeg
echo [INSTALACIÓN] Descargando FFmpeg...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip' -OutFile 'ffmpeg.zip'" || (
    echo [ERROR] Falló la descarga de FFmpeg
    pause
    exit /b 1
)

echo [INSTALACIÓN] Extrayendo FFmpeg...
powershell -Command "Expand-Archive -Path 'ffmpeg.zip' -DestinationPath 'ffmpeg' -Force" || (
    echo [ERROR] Falló la extracción de FFmpeg
    pause
    exit /b 1
)

setx PATH "%PATH%;%cd%\ffmpeg\bin" /M > nul 2>&1
echo [✔] FFmpeg instalado en: %cd%\ffmpeg\bin

:: 2. Verificar dependencias Python
:CheckPythonDeps
echo [INFO] Verificando dependencias Python...
pip show whisper > nul 2>&1
if %errorlevel% equ 0 (
    echo [✔] Whisper ya está instalado.
    goto :StartApp
) else (
    echo [INSTALACIÓN] Dependencias no encontradas. Instalando...
    goto :InstallPythonDeps
)

:InstallPythonDeps
echo [INSTALACIÓN] Actualizando pip...
pip install --upgrade pip || (
    echo [ERROR] Falló la actualización de pip
    pause
    exit /b 1
)

echo [INSTALACIÓN] Instalando dependencias...
pip install -r requirements.txt --force-reinstall || (
    echo [ERROR] Falló la instalación de dependencias
    pause
    exit /b 1
)

python -c "import whisper; print('[✔] Whisper verificado')" || (
    echo [ERROR] Falló la verificación de Whisper
    pause
    exit /b 1
)

:: 3. Iniciar la aplicación (app.py)
:StartApp
echo.
echo [✔] TODAS LAS DEPENDENCIAS INSTALADAS
echo [INFO] Iniciando la aplicación...
python app.py || (
    echo [ERROR] No se pudo iniciar app.py
    pause
    exit /b 1
)

pause