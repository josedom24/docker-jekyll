# docker-jekyll

En este proyecto se presenta  la construcción de una **imagen Docker con Jekyll ya instalado**, que nos permitirá crear distintos contenedores para generar cada uno de nuestros proyectos Jekyll de manera aislada.

## Ejemplo de uso

Supongamos que tenemos un proyecto Jekyll llamado `proyecto-jekyll` y queremos generar el HTML resultante en el directorio `html`. Además, queremos crear un contenedor llamado `contenedor-jekyll` para gestionar este proyecto de forma aislada.

Con el script `run.sh` que hemos definido, el proceso es muy sencillo. Basta con ejecutar:

```bash
./run.sh contenedor-jekyll ./proyecto-jekyll ./html
```

El comportamiento será el siguiente:

1. **Creación de la imagen Docker (si no existe):**
   El script comprobará si la imagen `docker-jekyll` ya existe. Si no, la construirá a partir del `Dockerfile`.

2. **Creación del contenedor (si no existe):**
   Si el contenedor `contenedor-jekyll` no existe, se creará, montando los volúmenes:

   * `./proyecto-jekyll` dentro del contenedor, para acceder al código fuente.
   * `./html` dentro del contenedor, para guardar el HTML generado.

   A continuación se ejecutará `install-gem.sh` para instalar las gemas necesarias según el `Gemfile` del proyecto.

3. **Generación del sitio:**
   Finalmente, se ejecutará `build-site.sh`, generando el HTML en el directorio `./html`.

4. **Contenedor activo para futuras ejecuciones:**
   El contenedor permanecerá en ejecución en segundo plano, lo que permite generar de nuevo el sitio simplemente volviendo a ejecutar `run.sh` o utilizando `docker exec` para ejecutar comandos adicionales dentro del contenedor.

Después de ejecutar el comando, el directorio `./html` contendrá todo el sitio estático generado por Jekyll, listo para ser servido por cualquier servidor web. Además, el contenedor `contenedor-jekyll` estará disponible para regenerar el sitio cuando hagamos cambios en el proyecto.

```bash
ls html
# index.html  about.html  css/  assets/ ...
```

Este enfoque permite gestionar múltiples proyectos Jekyll con distintas versiones de gemas sin que haya conflictos entre ellos, manteniendo cada proyecto completamente aislado dentro de su propio contenedor Docker.


## Trucos y buenas prácticas

* **Regenerar el sitio tras cambios:**
  Si modificas el contenido del proyecto Jekyll, basta con ejecutar de nuevo:

  ```bash
  ./run.sh contenedor-jekyll ./proyecto-jekyll ./html
  ```

  Esto ejecutará `build-site.sh` dentro del contenedor, actualizando el HTML.

* **Actualizar gemas o dependencias:**
  Si quieres instalar nuevas gemas o actualizar las existentes, puedes ejecutar:

  ```bash
  docker exec -i contenedor-jekyll /usr/local/bin/install-gem.sh ./proyecto-jekyll
  ```

* **Eliminar contenedores antiguos:**
  Para borrar un contenedor sin perder los datos generados en los volúmenes:

  ```bash
  docker rm -f contenedor-jekyll
  ```

* **Inspeccionar o ejecutar comandos adicionales:**
  Puedes abrir una shell dentro del contenedor:

  ```bash
  docker exec -it contenedor-jekyll bash
  ```