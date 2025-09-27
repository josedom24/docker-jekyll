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

# Si el contenedor existe
if docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME\$"; then
  echo "Contenedor existente '$CONTAINER_NAME', ejecutando build-site.sh..."
  # Arrancar si está parado
  if ! docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME\$"; then
    docker start "$CONTAINER_NAME"
  fi
  docker exec -i "$CONTAINER_NAME" /usr/local/bin/build-site.sh "$REPO_DIR" "$OUT_DIR"
else
  echo "Creando contenedor '$CONTAINER_NAME' y ejecutando install-gem.sh..."
  # Crear contenedor y ejecutar install-gem.sh
  docker run -dit --name "$CONTAINER_NAME" \
    -v "$REPO_DIR":"$REPO_DIR" \
    -v "$OUT_DIR":"$OUT_DIR" \
    docker-jekyll \
    bash -c "tail -f /dev/null"
    docker exec -i "$CONTAINER_NAME" /usr/local/bin/install-gem.sh "$REPO_DIR" 
  # Ejecutar build-site.sh
  docker exec -i "$CONTAINER_NAME" /usr/local/bin/build-site.sh "$REPO_DIR" "$OUT_DIR"
fi
