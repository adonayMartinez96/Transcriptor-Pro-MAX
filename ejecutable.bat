@echo off
SETLOCAL EnableDelayedExpansion
title Instalador de Whisper Transcriber Pro
mode con: cols=100 lines=30
color 0A

:: ==============================================
:: CONFIGURACIÓN INICIAL
:: ==============================================
set "LOG_FILE=install_log.txt"
echo [%date% %time%] Inicio de instalación > %LOG_FILE%
echo [INSTALADOR WHISPER TRANSCRIBER PRO] Iniciando proceso...
echo.

:: ==============================================
:: VERIFICACIÓN DE PYTHON
:: ==============================================
echo [🐍] Verificando instalación de Python... >> %LOG_FILE%
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [❌] Python no está instalado o no está en el PATH >> %LOG_FILE%
    echo [❌] Error: Python no encontrado
    echo [ℹ] Descargue Python desde https://www.python.org/downloads/
    pause
    exit /b 1
)

:: ==============================================
:: LIMPIEZA DE DEPENDENCIAS EXISTENTES
:: ==============================================
echo [🧹] Limpiando dependencias anteriores... >> %LOG_FILE%
echo [🧹] Desinstalando paquetes existentes...

:: Lista de paquetes a desinstalar
set "UNINSTALL_PACKAGES=whisper whisper-openai openai-whisper python-dotenv requests python-docx fpdf2"

for %%p in (%UNINSTALL_PACKAGES%) do (
    echo [ℹ] Desinstalando %%p... >> %LOG_FILE%
    pip uninstall %%p -y >nul 2>&1
    if !errorlevel! equ 0 (
        echo [✔] %%p desinstalado >> %LOG_FILE%
    ) else (
        echo [⚠] %%p no estaba instalado >> %LOG_FILE%
    )
)

:: ==============================================
:: INSTALACIÓN DE DEPENDENCIAS
:: ==============================================
echo [📦] Instalando dependencias... >> %LOG_FILE%

:: Lista de dependencias principales
set "DEPENDENCIES=openai-whisper python-dotenv requests python-docx fpdf2"

for %%d in (%DEPENDENCIES%) do (
    echo [ℹ] Instalando %%d... >> %LOG_FILE%
    pip install %%d --force-reinstall --no-cache-dir || (
        echo [❌] Error al instalar %%d >> %LOG_FILE%
        echo [❌] Falló la instalación de %%d
        pause
        exit /b 1
    )
)

:: ==============================================
:: VERIFICACIÓN DE INSTALACIÓN
:: ==============================================
echo [🔍] Verificando instalación... >> %LOG_FILE%
python -c "import whisper, dotenv, requests, docx, fpdf; print('Todas las dependencias están instaladas')" || (
    echo [❌] Error: Faltan dependencias >> %LOG_FILE%
    echo [❌] Algunas dependencias no se instalaron correctamente
    pause
    exit /b 1
)

:: ==============================================
:: INICIAR LA APLICACIÓN
:: ==============================================
echo [🚀] Iniciando la aplicación... >> %LOG_FILE%
echo.
echo [✔✔✔] INSTALACIÓN COMPLETADA CON ÉXITO
echo [ℹ] Iniciando Whisper Transcriber Pro...
python app.py || (
    echo [❌] Error al iniciar la aplicación >> %LOG_FILE%
    echo [❌] No se pudo iniciar app.py
    pause
    exit /b 1
)

:: ==============================================
:: FINALIZACIÓN
:: ==============================================
echo.
pause