# Docker Container
#######################################################################################################
###########  Origen de la instalacion							 ##############
FROM  phusion/baseimage:0.9.15
MAINTAINER  Javier Calles "jcalles@teravisiontech.com"


#######################################################################################################
###########  Variables de entorno y locales						 ##############
ENV LANG en_US.UTF-8
CMD ["/bin/bash"]
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
#######################################################################################################



###########  Actualizacion de origenes de paquetes					 ##############
RUN cd /tmp && curl -O http://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb \
&& dpkg -i puppetlabs-release-pc1-trusty.deb \
&& apt-get update \
&& apt-get -y install puppet git curl acl mysql-client\

#################### Instalacion de Ansible ################ agregado por EMIR REYES #################
&& apt-get -y install software-properties-common \
&& apt-add-repository ppa:ansible/ansible -y \
&& apt-get update \
&& apt-get -y install ansible
######################################################################################################

#&& unixodbc unixodbc-dev freetds-dev tdsodbc



#######################################################################################################
RUN echo -e "\n\n\n" | ssh-keygen -t rsa -f /tmp/llavessh -q -N ""
RUN cat /tmp/llavessh.pub >> /root/.ssh/authorized_keys
RUN echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config \
&& touch /root/.ssh/config \
&& chmod 0700 /root/.ssh/config \
&& echo   "Host * \n\t StrictHostKeyChecking no \n" >> /root/.ssh/config
#######################################################################################################



###########  ejecucion de clonado de repositorio git configuracion de pueppt		 ##############
COPY ./files/site.pp /etc/puppet/manifests/site.pp
COPY ./site.yml /tmp/site.yml

#######################################################################################################
RUN rm -f /etc/service/sshd/down \
&& /etc/my_init.d/00_regen_ssh_host_keys.sh \
&& apt-get update && apt-get  update


#######################################################################################################
VOLUME [ "/sys/fs/cgroup" ]


##########  Instala  Modulos de Puppet                                                    #############
RUN puppet module install thias/php \
&& puppet module install willdurand/composer \
&& puppet module install puppetlabs-apache \
&& puppet module install thias-postfix \
&& puppet module install ajcrowe-supervisord \
&& puppet module install puppetlabs-apt \
&& puppet module install treydock-gpg_key 

RUN apt-get update  \
&& puppet apply /etc/puppet/manifests/site.pp --modulepath=/etc/puppet/modules/
#######################################################################################################

COPY ./files/run.sh	/usr/local/bin/run.sh

##########  	   limpia								  #############
EXPOSE 22 80
VOLUME ["/keys"]

RUN apt-get clean \
&& chmod +x /usr/local/bin/run.sh
CMD ["/sbin/my_init","--"]
CMD ["/usr/local/bin/supervisord","-c","/etc/supervisord.conf","-n"]
