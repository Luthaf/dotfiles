#!/bin/bash

echo "!==============! Installing dev tools !===============!"

yum groupinstall -y "Development Tools"

# Nginx
echo "!==============! Installing nginx !===============!"
yum install -q -y epel-release
yum install -q -y nginx

groupadd www
usermod -a -G www nginx

# Python 3
echo "!==============! Installing Python 3.4 !===============!"
yum install -q -y wget zlib-devel openssl-devel sqlite-devel bzip2-devel

wget -q http://www.python.org/ftp/python/3.4.1/Python-3.4.1.tgz
tar -xf Python-3.4.1.tgz
cd Python-3.4.1
./configure -q --prefix=/usr/local
make -s && make -s altinstall
cd ..

rm -rf  Python-3.4.1  Python-3.4.1.tgz

# uWSGI
echo "!==============! Installing uWSGI !===============!"

pip3.4 -q install uwsgi
mkdir -p /etc/uwsgi/vassals

systemctl enable nginx uwsgi

# Postgresql
echo "!==============! Installing PostgreSQL !===============!"
yum install -q -y postgresql postgresql-devel postgresql-server python-psycopg2
pip3.4 -q install psycopg2

postgresql-setup initdb
systemctl enable postgresql
systemctl start postgresql
