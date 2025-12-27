#!/bin/bash
set -e

if [ $# -lt 2 ]; then
  echo "Uso: $0 <ruta-repositorio-jekyll> <ruta-salida-html>"
  exit 1
fi

SRC_DIR="$1"
DEST_DIR="$2"

echo "Usando repositorio en: $SRC_DIR"
echo "Generando HTML en: $DEST_DIR"

cd "$SRC_DIR"

# Generar el sitio
JEKYLL_ENV=production bundle exec jekyll build -d "$DEST_DIR"
