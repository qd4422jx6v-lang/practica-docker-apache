FROM debian:latest
RUN apt-get update && apt-get install -y apache2 elinks
RUN echo "<h1>Hola, soy Chus (Automatizado)</h1>" > /var/www/html/chus.html
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]