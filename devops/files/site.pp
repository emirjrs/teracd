## site.pp ##

node default {
include composer
class { '::postfix::server':
  myhostname              => 'default.teravisiontech.com',
  mydomain                => 'teravisiontech.com',
  mydestination           => "\$myhostname, localhost.\$mydomain, localhost, $fqdn",
  inet_interfaces         => 'all',
  message_size_limit      => '15360000', # 15MB
  mail_name               => 'accclink mail daemon',



}
class { 'apache':
  default_vhost => false,
  mpm_module => 'prefork',
  service_manage => false,
}

################################################
include apache::mod::rewrite 
apache::vhost{ 'default.teravisiontech.com':
	port => '80',
	docroot => '/var/www/html/',
	manage_docroot => false,
	docroot_owner => 'www-data',
	docroot_group => 'www-data',
	directories => [
	 	{
  		path => '/var/www/html',
 		allow_override => 'All',
  		options => 'Indexes FollowSymLinks MultiViews',
	rewrites => [ { comment      => 'Permalink Rewrites',
                      rewrite_base => '/'
                    },
                    { rewrite_rule => [ '^index\.php$ - [L]' ]
                    },
                    { rewrite_cond => [ '%{REQUEST_FILENAME} !-f',
                                        '%{REQUEST_FILENAME} !-d',
                                      ],
                      rewrite_rule => [ '. /index.php [L]' ],
                    }
                  ],
 },
],
}
##########################################################
class { 'apache::mod::php': }
php::module { [ 'mysql', 'mcrypt' , 'odbc' , 'sybase', 'curl', 'gd', 'apcu', 'cli', 'intl' ,'xmlrpc', 'sqlite' ]: }
php::ini { '/etc/php.ini':
  date_timezone => 'America/Caracas'
}
exec {"phpmcrypt":
	path => "/bin:/usr/bin:/usr/sbin",
	command => "php5enmod mcrypt",
}

##########################
class { 'supervisord':
  install_pip => true,
}

supervisord::program { 'apache_service':
  command             => '/usr/sbin/apache2ctl -D FOREGROUND',
  priority            => '100',
  program_environment => {
    'PATH'   => '/bin:/sbin:/usr/bin:/usr/sbin',
  }
}


supervisord::program { 'postfix_service':
  command             => 'service postfix restart',
  priority            => '102',
  program_environment => {
    'PATH'   => '/bin:/sbin:/usr/bin:/usr/sbin',
  }
}
supervisord::program { 'sshd_service':
  command             => '/usr/sbin/sshd -D',
  priority            => '104',
  program_environment => {
    'PATH'   => '/bin:/sbin:/usr/bin:/usr/sbin',
  }
}
supervisord::program { 'puppet_service':
  command             => 'puppet apply /etc/puppet/manifest/site.pp',
  priority            => '105',
  program_environment => {
    'PATH'   => '/bin:/sbin:/usr/bin:/usr/sbin',
  }
}
supervisord::program { 'run_service':
  command             => '/usr/local/bin/run.sh',
  priority            => '106',
  program_environment => {
    'PATH'   => '/bin:/sbin:/usr/bin:/usr/sbin',
  }
}

}
