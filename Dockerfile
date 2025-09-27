FROM ruby:3.2

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC

RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/jekyll

RUN gem install jekyll bundler


# Exponemos puerto por si quieres hacer `serve`
EXPOSE 4000

# Copiar script dentro de la imagen
COPY build-site.sh /usr/local/bin/build-site.sh
RUN chmod +x /usr/local/bin/build-site.sh

# Por defecto arrancamos bash, pero puedes cambiarlo por el script
CMD ["/usr/local/bin/build-site.sh", "/src", "/output"]
