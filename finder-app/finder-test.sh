#!/bin/sh
# Script de prueba para la asignación 4 - Adaptado para Buildroot
# Autor: juanA

set -e 
set -u 

# --- REQUISITO 4b: Rutas de configuración ---
# En Buildroot, los archivos de configuración deben estar en /etc/finder-app/conf
CONF_DIR=/etc/finder-app/conf
if [ -d "$CONF_DIR" ]; then
    username=$(cat "$CONF_DIR/username.txt")
else
    # Fallback para desarrollo local si no existe la ruta de Buildroot
    username=$(cat conf/username.txt)
fi

NUMFILES=10
WRITESTR=AESD_IS_AWESOME
WRITEDIR=/tmp/aeld-data

if [ $# -lt 3 ]; then
    echo "Usando valores por defecto"
else
    NUMFILES=$1
    WRITESTR=$2
    WRITEDIR=/tmp/aeld-data/$3
fi

# Configuración de directorios
rm -rf "$WRITEDIR"
mkdir -p "$WRITEDIR"

# --- REQUISITO 4b: Uso del PATH ---
# Eliminamos el "./" para que el sistema busque "writer" y "finder.sh" en /usr/bin
echo "Creando archivos usando el binario writer desde el PATH..."

for i in $(seq 1 $NUMFILES)
do
    # Ahora llamamos a 'writer' directamente (estará en /usr/bin/)
    writer "$WRITEDIR/${username}$i.txt" "$WRITESTR"
done

# Ejecutar finder.sh (también debe estar en el PATH)
OUTPUTSTRING=$(finder.sh "$WRITEDIR" "$WRITESTR")

# --- REQUISITO 4c: Escribir resultado en /tmp/assignment4-result.txt ---
echo "${OUTPUTSTRING}" > /tmp/assignment4-result.txt

# Limpieza opcional de datos de prueba
rm -rf /tmp/aeld-data

# Verificar si el resultado coincide con lo esperado
if echo "${OUTPUTSTRING}" | grep -qi "number of files are ${NUMFILES}" && echo "${OUTPUTSTRING}" | grep -qi "number of matching lines are ${NUMFILES}"; then
    echo "success"
    exit 0
else
    echo "failed: expected ${NUMFILES} files but got ${OUTPUTSTRING}"
    exit 1
fi