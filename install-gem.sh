#!/bin/bash
set -e

if [ $# -lt 1 ]; then
  echo "Uso: $0 <ruta-repositorio-jekyll>"
  exit 1
fi

SRC_DIR="$1"


echo "Instalando Gemfile de: $SRC_DIR"

cd "$SRC_DIR"

# Instalar dependencias si hay Gemfile
if [ -f "Gemfile" ]; then
  bundle install
fi

