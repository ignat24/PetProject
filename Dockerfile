FROM alpine:3.14

RUN apk --no-cache update
RUN apk add --no-cache apache2

WORKDIR /var/www/localhost/htdocs

COPY  app/page/index.html  /var/www/localhost/htdocs 
COPY  app/page/style.css  /var/www/localhost/htdocs 

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

EXPOSE 80