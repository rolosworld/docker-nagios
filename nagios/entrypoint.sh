#!/bin/sh

service nagios start

/usr/sbin/apache2 -D FOREGROUND -k start
