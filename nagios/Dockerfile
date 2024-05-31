FROM debian:latest as final-stage

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev openssl libssl-dev libmcrypt-dev bc gawk dc build-essential snmp libnet-snmp-perl gettext

WORKDIR /build

RUN wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.14.tar.gz
RUN tar xzf nagioscore.tar.gz

WORKDIR /build/nagioscore-nagios-4.4.14
RUN ./configure --with-httpd-conf=/etc/apache2/sites-enabled
RUN make all

RUN make install-groups-users
RUN usermod -a -G nagios www-data

RUN make install
RUN make install-daemoninit
RUN make install-commandmode
RUN make install-config
RUN make install-webconf
RUN a2enmod rewrite
RUN a2enmod cgi

#COPY ./apache.conf /usr/local/apache2/conf/httpd.conf
COPY ./entrypoint.sh /usr/bin/entrypoint.sh

ARG APACHE_RUN_DIR
ARG APACHE_RUN_USER
ARG APACHE_RUN_GROUP
ARG APACHE_LOG_DIR
ARG APACHE_PID_FILE
ARG APACHE_LOCK_DIR
ARG LANG
ARG NAGIOS_ADMIN
ARG NAGIOS_PASSWORD

RUN htpasswd -c -b /usr/local/nagios/etc/htpasswd.users $NAGIOS_ADMIN $NAGIOS_PASSWORD

EXPOSE 80

CMD ["/usr/bin/entrypoint.sh"]
