FROM yindaheng98/multibird-cms

ENV MYSQL_ADMIN_PASS administrator

ADD app/ /app
ADD webapps/ /jettybase/webapps
EXPOSE 3306 8080 80
VOLUME  ["/var/lib/mysql"]