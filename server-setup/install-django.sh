#!/bin/bash

echo "Enter git repository adress:"
read git_url
echo "Enter username:"
read username

while true
do
	echo "Enter password:"
	read -s password1
	echo "Enter password (again):"
	read -s password2
	if [ $password1 != $password2 ]; then
		echo "Passwords do not match"
	else
		break
	fi
done

useradd $username -G www
echo $password | passwd –-stdin $username

git clone $git_url /home/$username/www

pyvenv-3.4 /home/$username/pyvenv

chown -R $username:www /home/$username/www /home/$username/pyvenv

sed "s/{USERNAME}/$username/g" files/django.ini > /etc/uwsgi/vassals/$username.ini
sed "s/{USERNAME}/$username/g" files/django.conf > /etc/nginx/conf.d/available/$username.conf

ln -s /etc/nginx/conf.d/available/$username.conf /etc/nginx/conf.d/$username.conf

echo "
create user $username;
create database $username owner=$username;
" | psql

systemctl restart uwsgi nginx

chmod 755 /home/$username

echo "source /home/$username/pyvenv/bin/activate" >> /home/$username/.bashrc

echo "Done !"
echo
echo
echo "Dont forget to edit the following:"
echo "/etc/uwsgi/vassals/$username.ini"
echo "/etc/nginx/conf.d/$username.conf"
echo "The settings.py file"
echo
echo "And to install all required packages"
