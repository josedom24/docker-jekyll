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

# Copiar scripts dentro de la imagen
COPY build-site.sh /usr/local/bin/build-site.sh
RUN chmod +x /usr/local/bin/build-site.sh
COPY install-gem.sh /usr/local/bin/install-gem.sh
RUN chmod +x /usr/local/bin/install-gem.sh


CMD ["bash"]
