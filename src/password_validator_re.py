import re
import os

def is_valid(password):
    razones = []
    # [span_2](start_span)Regla: Longitud >= 8[span_2](end_span)
    if len(password) < 8:
        razones.append("longitud insuficiente")
    
    # [span_3](start_span)Regla: Al menos una mayúscula[span_3](end_span)
    if not re.search(r'[A-Z]', password):
        razones.append("no tiene mayúscula")
        
    # [span_4](start_span)Regla: Al menos un dígito[span_4](end_span)
    if not re.search(r'\d', password):
        razones.append("no tiene dígito")
        
    # [span_5](start_span)Regla: Solo letras y números[span_5](end_span)
    if not re.match(r'^[a-zA-Z0-9]+$', password):
        razones.append("tiene caracteres inválidos")
        
    return razones

def procesar_passwords():
    # [span_6](start_span)Crear carpeta out si no existe[span_6](end_span)
    if not os.path.exists('out'): 
        os.makedirs('out')
    
    validas = []
    invalidas_con_razon = []

    # [span_7](start_span)Leer archivo de entrada[span_7](end_span)
    try:
        with open('data/passwords_muestra.txt', 'r') as f:
            for line in f:
                pwd = line.strip()
                if not pwd: continue
                
                errores = is_valid(pwd)
                if not errores:
                    validas.append(pwd)
                else:
                    # [span_8](start_span)Guardar con sus razones de rechazo[span_8](end_span)
                    invalidas_con_razon.append(f"{pwd} -> {', '.join(errores)}")

        # [span_9](start_span)Guardar en archivos de salida[span_9](end_span)
        with open('out/validas.txt', 'w') as f:
            f.writelines(v + '\n' for v in validas)
        with open('out/invalidas.txt', 'w') as f:
            f.writelines(i + '\n' for i in invalidas_con_razon)

        print(f"Total Válidas: {len(validas)}")
        print(f"Total Inválidas: {len(invalidas_con_razon)}")
    except FileNotFoundError:
        print("Error: No se encontró el archivo en data/passwords_muestra.txt")

if _name_ == "_main_":
    procesar_passwords()
