#!/bin/bash

# Verificar que se haya pasado la información
if [ -z "$1" ]; then
    echo "Uso: ./src/log_reporter_grep.sh INFO|WARN|ERROR|DEBUG"
    exit 1
fi

LEVEL="$1"

# Se verifica que el nivel de log sea permitido antes de seguir
if [[ ! "$LEVEL" =~ ^(INFO|WARN|ERROR|DEBUG)$ ]]; then
    echo "Nivel inválido. Use INFO, WARN, ERROR o DEBUG."
    exit 1
fi

INPUT_FILE="data/log_muestra_app.log"
OUTPUT_DIR="out"
OUTPUT_FILE="$OUTPUT_DIR/${LEVEL,,}_validos.txt"

# Asegura la existencia de la carpeta out
mkdir -p "$OUTPUT_DIR"

# Busca el patrón fecha y nivel
grep -E "^\[$LEVEL\] [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} .+" "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Líneas válidas guardadas en $OUTPUT_FILE"

# Número de líneas no vacías
TOTAL_NO_VACIAS=$(grep -cve '^[[:space:]]*$' "$INPUT_FILE")

# Número de líneas válidas sin importar el nivel
TOTAL_VALIDAS=$(grep -Ec '^\[(INFO|WARN|ERROR|DEBUG)\] [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} .+' "$INPUT_FILE")

# Número de líneas sospechosas para el nivel especificado
TOTAL_SOSPECHOSAS=$(grep "$LEVEL" "$INPUT_FILE" | grep -Ev '^\['"$LEVEL"'\] [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} .+' | wc -l)

echo "Total líneas no vacías: $TOTAL_NO_VACIAS"
echo "Total líneas válidas: $TOTAL_VALIDAS"
echo "Total líneas sospechosas ($LEVEL): $TOTAL_SOSPECHOSAS"

# Número de válidas para el nivel especificado
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

