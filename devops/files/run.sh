#!/bin/bash
llave(){
if [ -f /tmp/llavessh ]
	then
	if [ -d  /keys ]
	then 
	mv /tmp/llavessh* /keys/
	fi
	else
		if ! [ -f  /keys/llavessh ]
		then
		echo "generando llave ssh..."
		echo -e "\n\n\n" | ssh-keygen -t rsa -f /keys/llavessh -q -N ""
		cat /keys/llavessh >> /root/.ssh/authorized_keys
		fi
fi
}

perm(){
if [ -d /var/www/html/ ]
then
chown -R www-data:www-data /var/www/html/
setfacl -m u:root:rwx /var/www/html/
fi
}
llave
perm
