# Práctica de aula: Docker y Apache
**Alumno:** Daniel Izquierdo Yanez
**Asignatura:** Despliegue de Aplicaciones Web / Servicios en Red

A continuación se detallan los pasos seguidos para la realización de la práctica de Docker y Apache.

### 1. Documentar los pasos seguidos en fichero Pasos-realizados.md
Este mismo documento cumple con el primer requisito de la práctica, detallando paso a paso los comandos ejecutados y adjuntando las evidencias gráficas.

### 2. Descargar imagen del hub de docker de debian
En primer lugar, procedemos a descargar la imagen oficial de Debian desde Docker Hub utilizando nuestra terminal local.
`docker pull debian`

<img width="1664" height="338" alt="1" src="https://github.com/user-attachments/assets/f06b941d-0713-4055-a88c-ca61573a5f93" />


### 3. Arrancar contenedor con nombre y puerto, interactivo, con terminal en modo detached
Arrancamos el contenedor en segundo plano (modo detached), le asignamos un nombre (`servidor_apache`) y mapeamos el puerto 80 del contenedor al puerto 8081 de nuestra máquina host para evitar conflictos.
`docker run -itd -p 8081:80 --name servidor_apache debian`

<img width="1446" height="756" alt="2" src="https://github.com/user-attachments/assets/c3b8aa25-9d89-4885-8da4-d77444290f92" />


### 4. Ejecutar una shell bash en el contenedor
Accedemos al interior del contenedor que acabamos de crear para poder instalar los servicios necesarios.
`docker exec -it servidor_apache bash`

### 5. Una vez dentro del contenedor, instalar paquete de apache2
Actualizamos los repositorios del contenedor e instalamos el servidor web Apache2.
`apt update && apt install -y apache2`

<img width="1486" height="335" alt="3" src="https://github.com/user-attachments/assets/45e6a507-2709-45dd-af9d-f52e73e72d67" />


### 6. Arrancar servicio apache
Iniciamos el servicio de Apache2 manualmente dentro del contenedor Debian.
`service apache2 start`

<img width="1493" height="331" alt="4" src="https://github.com/user-attachments/assets/a1960461-a0a4-4802-8815-3387b23551b4" />


### 7. Comprobar desde navegador que el servidor web responde
Accedemos desde el navegador de nuestra máquina host a la dirección `http://localhost:8081` para verificar que la página por defecto de Apache carga correctamente.

<img width="1190" height="732" alt="5" src="https://github.com/user-attachments/assets/f983b4a4-2a4b-497e-83f2-1f847eb21583" />


### 8. Crear una página nueva html llamada tu_nombre.html
Creamos una página HTML personalizada directamente en el directorio público de Apache.
`echo "<h1>Hola, soy Chus</h1>" > /var/www/html/chus.html`

<img width="1490" height="337" alt="6" src="https://github.com/user-attachments/assets/54a02830-e384-4f74-b4ef-0789d0695e18" />


### 9. Acceder desde navegador
Volvemos al navegador de nuestra máquina host y accedemos a la ruta del nuevo archivo para comprobar que se muestra el mensaje personalizado.
`http://localhost:8081/chus.html`

<img width="751" height="478" alt="7" src="https://github.com/user-attachments/assets/32c6f6f1-3267-48fa-bd5a-205d0d434de2" />


### 10. Acceder desde navegador de línea de comandos elinks
Instalamos el navegador de consola `elinks` dentro del contenedor y accedemos a nuestra web localmente (puerto 80 por defecto).
`apt install -y elinks`

<img width="1500" height="339" alt="8" src="https://github.com/user-attachments/assets/12db500b-ca34-45e0-a9a2-fbad33bf9a4c" />


`elinks http://localhost/chus.html`

<img width="1497" height="335" alt="9" src="https://github.com/user-attachments/assets/e5d405e0-d287-4a57-98ed-1ab0e839bd85" />


### 14. Comando que copia un archivo local a un contenedor
*(Nota: Este paso se adelantó durante la práctica para agrupar los comandos manuales).*
Desde una terminal en la máquina host, creamos un archivo de texto y lo copiamos dentro de la ruta web del contenedor usando `docker cp`.
`echo "Este es un archivo copiado" > archivo_prueba.txt`
`docker cp archivo_prueba.txt servidor_apache:/var/www/html/`

<img width="1493" height="337" alt="10" src="https://github.com/user-attachments/assets/7d26bd79-b503-4bcc-9b4d-f7d0ba17986d" />


---

## Fase 2: Automatización

### 11. Hacer fichero llamado Dockerfile que automatice los pasos anteriores
Creamos un directorio local para la práctica y dentro generamos un archivo `Dockerfile` con las instrucciones necesarias para automatizar la instalación de Apache, la creación de la página HTML y el arranque del servicio en primer plano.

<img width="931" height="214" alt="11" src="https://github.com/user-attachments/assets/24d11507-689b-425e-93f1-ce89a9ec4519" />


### 12. Crear la imagen a partir del dockerfile
Construimos nuestra propia imagen personalizada a la que hemos llamado `imagen_apache_chus`.
`docker build -t imagen_apache_chus .`

<img width="1494" height="337" alt="12" src="https://github.com/user-attachments/assets/2568f0d4-28f5-4035-b623-a2ff59e21b20" />


### 13. Ejecutar el contenedor
Levantamos un nuevo contenedor basado en nuestra imagen personalizada. Utilizamos el puerto 8082 para no crear conflicto con el servidor del paso 3.
`docker run -itd -p 8082:80 --name servidor_automatizado imagen_apache_chus`

<img width="1199" height="536" alt="13" src="https://github.com/user-attachments/assets/5b944612-9076-41fa-9def-f1f920eced2e" />


### 15. Crear fichero docker-compose.yml con un volumen local
Finalmente, creamos una carpeta local llamada `html` con un archivo `index.html` de prueba en su interior.

<img width="1479" height="337" alt="14" src="https://github.com/user-attachments/assets/4ec381ed-50af-4aaa-8e23-3a9ef6e973ca" />

Tras esto, creamos el archivo `docker-compose.yml` que orquestará el arranque del contenedor usando nuestra imagen y mapeando la carpeta recién creada al directorio `/var/www/html` de Apache. Le asignamos el puerto 8083.

<img width="678" height="359" alt="15" src="https://github.com/user-attachments/assets/13b374fd-a1fb-4a52-89f5-068652aaa69a" />

Para arrancar esta configuración, se ejecutaría:
`docker compose up -d`
