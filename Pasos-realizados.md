# Práctica de aula: Docker y Apache
**Alumno:** Daniel Izquierdo Yanez
**Asignatura:** Despliegue de Aplicaciones Web / Servicios en Red

A continuación se detallan los pasos seguidos para la realización de la práctica de Docker y Apache.

### 1. Documentar los pasos seguidos en fichero Pasos-realizados.md
Este mismo documento cumple con el primer requisito de la práctica, detallando paso a paso los comandos ejecutados y adjuntando las evidencias gráficas.

### 2. Descargar imagen del hub de docker de debian
En primer lugar, procedemos a descargar la imagen oficial de Debian desde Docker Hub utilizando nuestra terminal local.
`docker pull debian`
![Descarga de la imagen de Debian]

### 3. Arrancar contenedor con nombre y puerto, interactivo, con terminal en modo detached
Arrancamos el contenedor en segundo plano (modo detached), le asignamos un nombre (`servidor_apache`) y mapeamos el puerto 80 del contenedor al puerto 8081 de nuestra máquina host para evitar conflictos.
`docker run -itd -p 8081:80 --name servidor_apache debian`
![Arranque del contenedor]
### 4. Ejecutar una shell bash en el contenedor
Accedemos al interior del contenedor que acabamos de crear para poder instalar los servicios necesarios.
`docker exec -it servidor_apache bash`

### 5. Una vez dentro del contenedor, instalar paquete de apache2
Actualizamos los repositorios del contenedor e instalamos el servidor web Apache2.
`apt update && apt install -y apache2`
![Acceso al contenedor e instalación de Apache]

### 6. Arrancar servicio apache
Iniciamos el servicio de Apache2 manualmente dentro del contenedor Debian.
`service apache2 start`
![Arranque del servicio Apache]

### 7. Comprobar desde navegador que el servidor web responde
Accedemos desde el navegador de nuestra máquina host a la dirección `http://localhost:8081` para verificar que la página por defecto de Apache carga correctamente.
![Comprobación en navegador host]

### 8. Crear una página nueva html llamada tu_nombre.html
Creamos una página HTML personalizada directamente en el directorio público de Apache.
`echo "<h1>Hola, soy Chus</h1>" > /var/www/html/chus.html`
![Creación de página HTML personalizada]
### 9. Acceder desde navegador
Volvemos al navegador de nuestra máquina host y accedemos a la ruta del nuevo archivo para comprobar que se muestra el mensaje personalizado.
`http://localhost:8081/chus.html`
![Acceso a la página personalizada en el navegador]

### 10. Acceder desde navegador de línea de comandos elinks
Instalamos el navegador de consola `elinks` dentro del contenedor y accedemos a nuestra web localmente (puerto 80 por defecto).
`apt install -y elinks`
![Instalación de elinks]

`elinks http://localhost/chus.html`
![Visualización web desde elinks]

### 14. Comando que copia un archivo local a un contenedor
*(Nota: Este paso se adelantó durante la práctica para agrupar los comandos manuales).*
Desde una terminal en la máquina host, creamos un archivo de texto y lo copiamos dentro de la ruta web del contenedor usando `docker cp`.
`echo "Este es un archivo copiado" > archivo_prueba.txt`
`docker cp archivo_prueba.txt servidor_apache:/var/www/html/`
![Copia de archivo local a contenedor]

---

## Fase 2: Automatización

### 11. Hacer fichero llamado Dockerfile que automatice los pasos anteriores
Creamos un directorio local para la práctica y dentro generamos un archivo `Dockerfile` con las instrucciones necesarias para automatizar la instalación de Apache, la creación de la página HTML y el arranque del servicio en primer plano.
![Creación del Dockerfile]

### 12. Crear la imagen a partir del dockerfile
Construimos nuestra propia imagen personalizada a la que hemos llamado `imagen_apache_chus`.
`docker build -t imagen_apache_chus .`
![Construcción de la imagen personalizada]

### 13. Ejecutar el contenedor
Levantamos un nuevo contenedor basado en nuestra imagen personalizada. Utilizamos el puerto 8082 para no crear conflicto con el servidor del paso 3.
`docker run -itd -p 8082:80 --name servidor_automatizado imagen_apache_chus`
![Ejecución del contenedor automatizado]

### 15. Crear fichero docker-compose.yml con un volumen local
Finalmente, creamos una carpeta local llamada `html` con un archivo `index.html` de prueba en su interior.
![Creación de directorio para volumen]

Tras esto, creamos el archivo `docker-compose.yml` que orquestará el arranque del contenedor usando nuestra imagen y mapeando la carpeta recién creada al directorio `/var/www/html` de Apache. Le asignamos el puerto 8083.
![Creación del archivo docker-compose.yml]
Para arrancar esta configuración, se ejecutaría:
`docker compose up -d`