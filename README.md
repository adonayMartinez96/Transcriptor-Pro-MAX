# **Manual de Instalación y Uso - Whisper Transcriber Pro MAX**  

## **📌 Objetivo de la Aplicación**  
**Whisper Transcriber Pro MAX** es una herramienta de transcripción y resumen automático de audio/video que utiliza inteligencia artificial para:  

✅ **Transcribir** archivos de audio o video a texto con marcas de tiempo.  
✅ **Generar resúmenes automáticos** usando el modelo DeepSeek (OpenRouter).  
✅ **Exportar resultados** en múltiples formatos (TXT, DOCX, PDF).  
✅ **Optimizar tiempo** en la generación de transcripciones precisas.  

**Tecnologías clave:**  
- **Whisper (OpenAI)**: Para transcripciones de alta precisión.  
- **DeepSeek (IA)**: Para resúmenes contextuales.  
- **Interfaz gráfica (Tkinter)**: Fácil de usar sin comandos.  

---

## **⚙️ Requisitos del Sistema**  
- **Sistema Operativo**: Windows 10/11, macOS o Linux.  
- **Python**: Versión 3.10 o superior.  
- **Espacio en disco**: ~2 GB (para modelos de Whisper).  
- **Conexión a Internet**: Para descargar dependencias y usar la API de DeepSeek.  

---

## **📥 Instalación Paso a Paso**  

### **1️⃣ Clonar o Descargar el Repositorio**  
```bash
git clone https://github.com/tu-usuario/Whisper-Transcriber-Pro.git
cd Whisper-Transcriber-Pro
```  
*(Si no usas Git, descarga el ZIP y extráelo)*  

### **2️⃣ Instalar Dependencias (Automático con el Script)**  
🔹 **Windows**:  
- Ejecuta **`install_and_run.bat`** (haz doble clic).  
- **Seguir las instrucciones** si pide permisos.  

🔹 **Linux/macOS**:  
```bash
chmod +x install_and_run.sh
./install_and_run.sh
```  

### **3️⃣ Configuración Inicial**  
- **Editar `.env`** (si usas DeepSeek):  
  ```env
  DEEPSEEK_API_KEY="tu_api_key_de_openrouter"
  ```  
  *(Opcional: Si no la tienes, la app sigue funcionando sin resúmenes automáticos)*  

---

## **🚀 Cómo Usar la Aplicación**  

### **1️⃣ Interfaz Principal**  
- **Seleccionar archivo** (MP3, MP4, WAV, etc.).  
- **Elegir modelo de Whisper** (recomendado: "Base").  
- **Seleccionar formatos de exportación** (TXT, DOCX, PDF).  

### **2️⃣ Proceso de Transcripción**  
1. Haz clic en **"TRANSCRIBIR"**.  
2. Espera a que termine (la barra de progreso muestra el avance).  
3. **Resultados guardados** en la misma carpeta del archivo original.  

### **3️⃣ Generar Resumen (Opcional con API Key)**  
- Haz clic en **"GENERAR RESUMEN"** después de la transcripción.  
- El resumen se exporta junto con la transcripción.  

---

## **⚠️ Solución de Problemas Comunes**  

| **Error** | **Solución** |  
|-----------|--------------|  
| *"Error loading c10_cuda.dll"* | Instalar PyTorch para CPU: `pip install torch==2.1.0+cpu` |  
| *"FFmpeg no encontrado"* | Ejecutar `install_ffmpeg_windows()` o instalarlo manualmente |  
| *"API Key no válida"* | Verificar la clave en [OpenRouter](https://openrouter.ai/keys) |  

---

## **🔍 Ejemplo de Resultados**  
- **Transcripción**:  
  ```text
  0:00 Hola, bienvenidos a este tutorial...  
  0:05 Hoy aprenderemos a usar Whisper...  
  ```  
- **Resumen IA**:  
  ```text
  El video introduce el uso de Whisper para transcripciones...  
  ```  

---

## **📌 Notas Finales**  
- **Sin GPU**: Usa modelos pequeños ("Tiny", "Base") para mayor velocidad.  
- **Con GPU NVIDIA**: Instala CUDA para mejor rendimiento.  
- **Personalización**: Modifica `SUMMARY_PROMPT` en `.env` para ajustar los resúmenes.  

¡Listo! 🎉 Ahora puedes transcribir y resumir cualquier audio/video fácilmente.  

**Descarga el proyecto**: [GitHub Repo Link](#) *(simulado)*  

--- 

¿Necesitas ayuda adicional? ¡Abre un *issue* en el repositorio! 🛠️
