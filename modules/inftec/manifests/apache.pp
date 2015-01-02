# Set up Apache Web Server
class inftec::apache {
	class { '::apache': 
		docroot => '/var/www/html', # Defaults to /var/www in Puppet
		mpm_module => 'prefork', # Needed for the PHP mod
		require => Package['nagios3'], # Make sure apache is configured after nagios
	}
	
	# Install PHP (needed by Nagios)
	class {'::apache::mod::php':
		# Defaults are good for us
		#require => Class['::apache'], # Obviously, mod dependencies are automatically resolved correctly by ::apache
	}
	
	# Default www vHost on port 80
#	apache::vhost { 'puppet.example.com':
#		port    => '80',
#		docroot => '/var/www/html',
#	}
	
	# We'll load the Nagios config from the config file and avoid configure everything within Puppet...
	apache::custom_config { 'nagios3':
		source => '/etc/apache2/conf-available/nagios3.conf',
		require => Class['::apache'],
	}
}