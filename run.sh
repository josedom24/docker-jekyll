#!/bin/bash
set -e

if [ $# -lt 3 ]; then
  echo "Uso: $0 <nombre-contenedor> <ruta-repositorio-jekyll> <ruta-salida-html>"
  exit 1
fi

CONTAINER_NAME="$1"
REPO_DIR=$(realpath "$2")
OUT_DIR=$(realpath "$3")

# Construir imagen si no existe
docker image inspect docker-jekyll >/dev/null 2>&1 || \
  docker build -t docker-jekyll .

# Si el contenedor existe y está parado, arrancarlo
if docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME\$"; then
  echo "Reanudando contenedor existente '$CONTAINER_NAME'..."
  docker start -ai "$CONTAINER_NAME"
else
  # Ejecutar el contenedor por primera vez
  docker run -it --name "$CONTAINER_NAME" \
    -v "$REPO_DIR":"$REPO_DIR" \
    -v "$OUT_DIR":"$OUT_DIR" \
    docker-jekyll \
    /usr/local/bin/build-site.sh "$REPO_DIR" "$OUT_DIR"
fi
