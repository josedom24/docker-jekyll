#!/bin/bash
set -e

if [ $# -lt 2 ]; then
  echo "Uso: $0 <ruta-repositorio-jekyll> <ruta-salida-html>"
  exit 1
fi

REPO_DIR=$(realpath "$1")
OUT_DIR=$(realpath "$2")

# Construir imagen si no existe
docker image inspect docker-jekyll >/dev/null 2>&1 || \
  docker build -t docker-jekyll .

# Ejecutar el contenedor con rutas locales
docker run --rm -it \
  -v "$REPO_DIR":"$REPO_DIR" \
  -v "$OUT_DIR":"$OUT_DIR" \
  docker-jekyll \
  /usr/local/bin/build-site.sh "$REPO_DIR" "$OUT_DIR"
