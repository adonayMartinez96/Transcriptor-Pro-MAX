@echo off
SETLOCAL

:: 1. Desinstalar todos los paquetes Python relacionados
echo [DESINSTALACIÓN] Eliminando paquetes Python...
pip uninstall -y torch torchaudio whisper openai-whisper python-docx fpdf2 ffmpeg-python python-dotenv requests tqdm numpy > nul 2>&1

:: 2. Eliminar FFmpeg si existe
echo [DESINSTALACIÓN] Eliminando FFmpeg...
where ffmpeg > nul 2>&1 && (
    taskkill /f /im ffmpeg.exe > nul 2>&1
    del /f /q "%PROGRAMFILES%\ffmpeg\*.*" > nul 2>&1
    rmdir /s /q "%PROGRAMFILES%\ffmpeg" > nul 2>&1
    setx PATH "%PATH:;%PROGRAMFILES%\ffmpeg\bin=%" /M > nul 2>&1
)

:: 3. Limpiar caché y residuos
echo [DESINSTALACIÓN] Limpiando caché...
pip cache purge > nul 2>&1
rd /s /q "%USERPROFILE%\AppData\Local\Temp\whisper" > nul 2>&1

:: 4. Confirmación
echo.
echo [✔] DESINSTALACIÓN COMPLETADA: Máquina lista para instalación limpia
echo.
pause