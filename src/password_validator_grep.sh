#!/bin/bash

INPUT="data/passwords_muestra.txt"
OUT_DIR="out"

mkdir -p "$OUT_DIR"

VALID_FILE="$OUT_DIR/validas.txt"
INVALID_FILE="$OUT_DIR/invalidas.txt"

> "$VALID_FILE"
> "$INVALID_FILE"

total_valid=0
total_invalid=0

while IFS= read -r password
do
    razones=""

    # Ignorar líneas vacías
    if [ -z "$password" ]; then
        continue
    fi

    # 1. Solo letras y números
    if ! echo "$password" | grep -q '^[A-Za-z0-9]\+$'; then
        razones+="tiene caracteres inválidos; "
    fi

    # 2. Longitud >= 8
    if ! echo "$password" | grep -q '^.\{8,\}$'; then
        razones+="longitud insuficiente; "
    fi

    # 3. Al menos una mayúscula
    if ! echo "$password" | grep -q '[A-Z]'; then
        razones+="no tiene mayúscula; "
    fi

    # 4. Al menos un dígito
    if ! echo "$password" | grep -q '[0-9]'; then
        razones+="no tiene dígito; "
    fi

    if [ -z "$razones" ]; then
        echo "$password" >> "$VALID_FILE"
        total_valid=$((total_valid + 1))
    else
        echo "$password -> $razones" >> "$INVALID_FILE"
        total_invalid=$((total_invalid + 1))
    fi

done < "$INPUT"

echo "Total válidas: $total_valid"
echo "Total inválidas: $total_invalid"
