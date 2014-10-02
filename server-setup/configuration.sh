#!/bin/bash

echo "!==============! Configuration of uWSGI !===============!"
# .ini file for uWSGI emperor
cat files/emperor.ini > /etc/uwsgi/emperor.ini

# systemd service file for uwsgi
cat files/uwsgi.service > /etc/systemd/system/uwsgi.service

echo "
d /var/log/uwsgi 0755 nginx www -
d /run/uwsgi 0755 nginx www -
" > /etc/tmpfiles.d/uwsgi.conf
systemd-tmpfiles --create


echo "!==============! Configuration of nginx !===============!"
cat files/nginx.conf > /etc/nginx/nginx.conf

mkdir /etc/nginx/conf.d/available
mv /etc/nginx/conf.d/*.conf /etc/nginx/conf.d/available 

# Opening the 80 port on firewall
firewall-cmd --zone=public --add-service=http --permanent

# SELinux security rule for nginx
semodule -i files/nginx.pp

echo "!==============! Configuration of postgresql !===============!"
su - postgres -c "echo \"alter user postgres with password '$RANDOM-$RANDOM';
create user root with password '$RANDOM-$RANDOM' superuser;
create database root owner=root;
\" | psql ; exit"

echo "
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     peer
" > /var/lib/pgsql/data/pg_hba.conf

systemctl restart nginx uwsgi postgresql
