#!/bin/sh

# Verificar argumentos
if [ $# -ne 2 ]; then
    echo "Error: Se requieren 2 argumentos. 1) Ruta a directorio 2) Cadena a buscar."
    exit 1
fi

filesdir=$1
searchstr=$2

# Verificar si el directorio existe
if [ ! -d "$filesdir" ]; then
    echo "Error: $filesdir no es un directorio."
    exit 1
fi

# Contar archivos (X)
# -type f busca solo archivos
X=$(find "$filesdir" -type f | wc -l)

# Contar líneas coincidentes (Y)
# -r es recursivo, para buscar en subdirectorios
Y=$(grep -r "$searchstr" "$filesdir" | wc -l)

echo "The number of files are $X and the number of matching lines are $Y"
