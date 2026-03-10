#!/bin/sh

if [ $# -ne 2 ]; then
    echo "Error: Se requieren 2 argumentos. 1) Ruta completa al archivo 2) Texto a escribir."
    exit 1
fi

writefile=$1
writestr=$2

# Obtener la ruta del directorio (sin el nombre del archivo)
dirpath=$(dirname "$writefile")

# Crear el directorio si no existe (-p crea carpetas padres si faltan)
mkdir -p "$dirpath"

# Crear el archivo o sobrescribirlo
echo "$writestr" > "$writefile"

# Verificar si la creación fue exitosa
if [ $? -ne 0 ]; then
    echo "Error: No se pudo crear el archivo."
    exit 1
fi
