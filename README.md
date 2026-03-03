Este repositorio tiene analizadores de texto, utilicé Python y expresiones regulares. 
Sobre la estructura: 
data/: Contiene los archivos de entrada (log_muestra_app.log y passwords_muestra.txt).  
src/: Contiene los scripts de Python para el análisis y validación.  
out/: Carpeta generada automáticamente donde se guardan los reportes y resultados.
Analizando los script: 
Analizador de Logs (log_reporter_re.py)
Este script extrae líneas de un archivo de log basándose en un nivel de severidad (INFO, WARN, ERROR, DEBUG) y verifica que cumplan con el formato: [NIVEL] AAAA-MM-DD HH:MM:SS Mensaje.  
Comando: python src/log_reporter_re.py
Salida: Genera un archivo .txt con las líneas válidas y un reporte en formato .json.  
2. Validador de Contraseñas (password_validator_re.py)
Este script evalúa contraseñas bajo las siguientes reglas: longitud mínima de 8, al menos una mayúscula, al menos un dígito y sin caracteres especiales.  
Comando: python src/password_validator_re.py
Salida: Clasifica las contraseñas en validas.txt e invalidas.txt, detallando las razones del rechazo
