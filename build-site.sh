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

# Instalar dependencias si hay Gemfile
if [ -f "Gemfile" ]; then
  bundle install
fi

# Generar el sitio
bundle exec jekyll build -d "$DEST_DIR"
