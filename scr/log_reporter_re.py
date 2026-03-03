import re
import os
import json
import sys

def analizar_logs():
    # Pedir el nivel al usuario (INFO, WARN, etc.)
    nivel_buscado = input("Introduce el nivel a extraer (INFO, WARN, ERROR, DEBUG): ").upper()
    
    # Crear carpeta out si no existe
    if not os.path.exists('out'):
        [span_13](start_span)os.makedirs('out')[span_13](end_span)

    [span_14](start_span)archivo_log = 'data/log_muestra_app.log'[span_14](end_span)
    regex_formato = rf'^\[({nivel_buscado})\] \d{{4}}-\d{{2}}-\d{{2}} \d{{2}}:\d{{2}}:\d{{2}} .+$'
    
    validas = []
    sospechosas = 0
    total_no_vacias = 0

    with open(archivo_log, 'r') as f:
        for linea in f:
            linea = linea.strip()
            if not linea: continue
            total_no_vacias += 1
            
            # Si cumple el formato y nivel
            if re.match(regex_formato, linea):
                validas.append(linea)
            # Si contiene el nivel pero el formato está mal
            elif nivel_buscado in linea:
                [span_15](start_span)sospechosas += 1[span_15](end_span)

    # Guardar resultados
    nombre_salida = f"out/{nivel_buscado.lower()}_validos.txt"
    with open(nombre_salida, 'w') as f:
        for v in validas:
            f.write(v + '\n')

    # Generar JSON de reporte
    reporte = {
        "total_no_vacias": total_no_vacias,
        "validas": len(validas),
        "sospechosas": sospechosas
    }
    with open('out/reporte_log.json', 'w') as f:
        [span_16](start_span)json.dump(reporte, f)[span_16](end_span)

    print(f"Total no vacías: {total_no_vacias}")
    print(f"Válidas: {len(validas)}")
    print(f"Sospechosas: {sospechosas}")

if _name_ == "_main_":
    analizar_logs()
