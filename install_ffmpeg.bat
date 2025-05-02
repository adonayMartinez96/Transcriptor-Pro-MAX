@echo off
SETLOCAL
title Instalador de FFmpeg - Manteniendo ventana abierta

:: 1. Configurar consola para mejor visibilidad
mode con: cols=100 lines=30
color 0A
echo.

:: 2. Iniciar registro de instalación
echo [%date% %time%] Iniciando instalacion de FFmpeg > install_log.txt
echo [INSTALADOR FFMPEG] Iniciando proceso...
echo Proceso completo se registra en install_log.txt
echo.

:: 3. Configurar rutas
set "INSTALL_DIR=%~dp0ffmpeg"
set "FFMPEG_EXE=%INSTALL_DIR%\bin\ffmpeg.exe"
set "ZIP_FILE=%INSTALL_DIR%\ffmpeg.zip"
set "DOWNLOAD_URL=https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"

:: 4. Verificar instalación existente
if exist "%FFMPEG_EXE%" (
   echo [✔] FFmpeg ya está instalado en: >> install_log.txt
   echo %FFMPEG_EXE% >> install_log.txt
   echo [✔] FFmpeg ya está instalado en:
   echo     "%FFMPEG_EXE%"
   goto :MenuFinal
)

:: 5. Crear directorio si no existe
if not exist "%INSTALL_DIR%" (
   echo [📁] Creando directorio de instalacion... >> install_log.txt
   echo [📁] Creando directorio de instalacion...
   mkdir "%INSTALL_DIR%"
)

:: 6. Descargar FFmpeg
echo [📥] Descargando FFmpeg... >> install_log.txt
echo [📥] Descargando FFmpeg...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest '%DOWNLOAD_URL%' -OutFile '%ZIP_FILE%'"
if not exist "%ZIP_FILE%" (
   echo [❌] Error en la descarga >> install_log.txt
   echo [❌] Error en la descarga
   echo URL usada: %DOWNLOAD_URL% >> install_log.txt
   goto :ErrorInstalacion
)

:: 7. Extraer archivos
echo [📦] Extrayendo FFmpeg... >> install_log.txt
echo [📦] Extrayendo FFmpeg...
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%INSTALL_DIR%' -Force"
del "%ZIP_FILE%"

:: 8. Verificar instalación
if not exist "%FFMPEG_EXE%" (
   echo [❌] Archivos extraidos pero no se encontró ffmpeg.exe >> install_log.txt
   echo [❌] Archivos extraidos pero no se encontró ffmpeg.exe
   echo Contenido del directorio: >> install_log.txt
   dir "%INSTALL_DIR%" /s >> install_log.txt
   goto :ErrorInstalacion
)

:: 9. Configurar PATH
echo [⚙] Configurando PATH del sistema... >> install_log.txt
echo [⚙] Configurando PATH del sistema...
setx PATH "%PATH%;%INSTALL_DIR%\bin" /M >nul 2>&1
if %errorlevel% neq 0 (
   echo [⚠] No se pudo modificar el PATH global >> install_log.txt
   echo [⚠] No se pudo modificar el PATH global
   echo [ℹ] Ejecute como Administrador para acceso completo >> install_log.txt
)

:InstalacionExitosa
echo [✔✔✔] INSTALACION COMPLETADA CON EXITO >> install_log.txt
echo [✔✔✔] INSTALACION COMPLETADA CON EXITO
echo FFmpeg instalado en: "%FFMPEG_EXE%" >> install_log.txt
echo FFmpeg instalado en: "%FFMPEG_EXE%"
goto :MenuFinal

:ErrorInstalacion
echo [❌❌❌] ERROR EN LA INSTALACION >> install_log.txt
echo [❌❌❌] ERROR EN LA INSTALACION
echo Revise el archivo install_log.txt para detalles >> install_log.txt

:MenuFinal
echo.
echo ------------------------------------------
echo  Instalacion finalizada. Opciones:
echo  1. Ver el log completo (install_log.txt)
echo  2. Probar FFmpeg
echo  3. Salir
echo ------------------------------------------
set /p opcion="Seleccione una opcion (1-3): "

if "%opcion%"=="1" (
   notepad install_log.txt
   goto :MenuFinal
)
if "%opcion%"=="2" (
   echo Probando FFmpeg... >> install_log.txt
   echo [TEST] Resultado de ffmpeg -version: >> install_log.txt
   "%FFMPEG_EXE%" -version >> install_log.txt
   "%FFMPEG_EXE%" -version
   pause
   goto :MenuFinal
)
if "%opcion%"=="3" exit

goto :MenuFinal