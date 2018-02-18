#name of container: zoneminder-nginx
#versison of container: 0.0.1
FROM ubuntu:16.04 
MAINTAINER Vadim Vagin "vadikvs666@gmail.com"
ENV TZ Asia/Omsk
ENV PORT 8080
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:iconnor/zoneminder && echo $TZ > /etc/timezone && apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server mysql-client zoneminder nginx-extras fcgiwrap ffmpeg nginx php-fpm \
                    && apt-get clean
COPY zm.conf /etc/nginx/sites-available/zoneminder
RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/zoneminder /etc/nginx/sites-enabled/zoneminder
RUN chown www-data:www-data /etc/zm/zm.conf
RUN sed  -i "s|\;date.timezone =|date.timezone = \"${TZ:-Asia/Omsk}\"|" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/8080/"$PORT"/1" /etc/nginx/sites-available/zoneminder
COPY start.sh /etc/start.sh
RUN mkdir -p /var/run/mysqld && chown mysql:mysql /var/run/mysqld
CMD ["/etc/start.sh"]
