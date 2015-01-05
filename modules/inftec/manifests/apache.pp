# Set up Apache Web Server
class inftec::apache (
	$fwHttpOpen = true,
	$fwHttpsOpen = true,
) {
	class { '::apache':
		docroot => '/var/www/html', # Defaults to /var/www in Puppet
		mpm_module => 'prefork', # Needed for the PHP mod
		
		 # Set up a default SSL vHost
		default_ssl_vhost => true,
		default_ssl_cert => '/etc/ssl/certs/ssl-cert-test.pem',
		default_ssl_key => '/etc/ssl/private/ssl-cert-test.key',
		
		require => Package['nagios3'], # Make sure apache is configured after nagios
	}
	
	# Set up an SSL vHost
	
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
	
	# Configure Firewall
	if $fwHttpOpen {
		firewall { '200 allow http access':
			port   => 80,
			proto  => tcp,
			action => accept,
		}
	}
	if $fwHttpsOpen {
		firewall { '201 allow https access':
			port   => 443,
			proto  => tcp,
			action => accept,
		}
	}
}