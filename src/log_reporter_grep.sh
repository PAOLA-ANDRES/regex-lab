#!/bin/bash

# Verificar que se haya pasado un argumento
if [ -z "$1" ]; then
    echo "Uso: ./src/log_reporter_grep.sh INFO|WARN|ERROR|DEBUG"
    exit 1
fi

LEVEL="$1"

# Validamos el  nivel
if [[ ! "$LEVEL" =~ ^(INFO|WARN|ERROR|DEBUG)$ ]]; then
    echo "Nivel inválido. Use INFO, WARN, ERROR o DEBUG."
    exit 1
fi

INPUT_FILE="data/log_muestra_app.log"
OUTPUT_DIR="out"
OUTPUT_FILE="$OUTPUT_DIR/${LEVEL,,}_validos.txt"

# Crear carpeta out si no existe
mkdir -p "$OUTPUT_DIR"

# Extraer líneas válidas con el nivel especificado
grep -E "^\[$LEVEL\] [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} .+" "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Líneas válidas guardadas en $OUTPUT_FILE"

# Total de líneas no vacías
TOTAL_NO_VACIAS=$(grep -cve '^[[:space:]]*$' "$INPUT_FILE")

# Total de líneas válidas (cualquier nivel)
TOTAL_VALIDAS=$(grep -Ec '^\[(INFO|WARN|ERROR|DEBUG)\] [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} .+' "$INPUT_FILE")

# Total de líneas sospechosas para el nivel especificado
TOTAL_SOSPECHOSAS=$(grep "$LEVEL" "$INPUT_FILE" | grep -Ev '^\['"$LEVEL"'\] [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} .+' | wc -l)

echo "Total líneas no vacías: $TOTAL_NO_VACIAS"
echo "Total líneas válidas: $TOTAL_VALIDAS"
echo "Total líneas sospechosas ($LEVEL): $TOTAL_SOSPECHOSAS"

# Total válidas para el nivel especificado
TOTAL_VALIDAS_NIVEL=$(grep -Ec "^\[$LEVEL\] [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} .+" "$INPUT_FILE")

JSON_FILE="$OUTPUT_DIR/reporte_log.json"

cat > "$JSON_FILE" <<EOF
{
  "nivel": "$LEVEL",
  "total_lineas_no_vacias": $TOTAL_NO_VACIAS,
  "total_lineas_validas": $TOTAL_VALIDAS,
  "total_lineas_validas_nivel": $TOTAL_VALIDAS_NIVEL,
  "total_lineas_sospechosas_nivel": $TOTAL_SOSPECHOSAS
}
EOF

echo "Reporte JSON generado en $JSON_FILE"

