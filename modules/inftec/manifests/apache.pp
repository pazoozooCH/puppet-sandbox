# Set up Apache Web Server
class inftec::apache (
	$fwHttpOpen = true,
	$fwHttpsOpen = true,
) {
	class { '::apache':
		default_vhost => false,
		docroot => '/var/www/html', # Defaults to /var/www in Puppet
		mpm_module => 'prefork', # Needed for the PHP mod
		
		 # Set up a default SSL vHost
		default_ssl_vhost => true,
		default_ssl_cert => '/etc/ssl/certs/ssl-cert-test.pem',
		default_ssl_key => '/etc/ssl/private/ssl-cert-test.key',
		
		require => Package['nagios3'], # Make sure apache is configured after nagios
	}
	# Set up a redirecting vHost that forwards all http traffic to https
	apache::vhost { "$fqdn":
		port => 80,
		docroot => '/var/www/html',
		redirect_source => '/',
		redirect_dest => "https://$fqdn/",
	}
	
	# Set up a proxy for 'wiki.example.com'
	apache::vhost { 'wiki.example.com':
		port => 443,
		ssl => true,
		docroot => '/var/www/html', # TODO: Not really needed...
		
		proxy_pass => [
			# Proxy pass for JIRA
			{ 'path' => '/', 'url' => 'http://client1.example.com:8080/' },
		],
	}
	
	/* Not using DNS to distinguish between apps as it makes things more complicated...
	# Set up a vHost for nagios.example.com, using https
	apache::vhost { 'nagios.example.com':
		port => 443,
		ssl => true,
		docroot => '/var/www/html2', # TODO: Not really needed...
		# proxy_dest => 'https://puppet.example.com/nagios3/',
		
		# Redirect / to /nagios3
		#redirect_source => '/',
		#redirect_dest => '/nagios3/',
		
		# Make /nagios3 available directly at / for nagios.example.com
		proxy_pass => [
			{ 'path' => '/cgi-bin/nagios3', 'url' => 'http://puppet.example.com/nagios3/cgi-bin' },
			{ 'path' => '/nagios3', 'url' => 'http://puppet.example.com/nagios3/' },
			{ 'path' => '/', 'url' => 'http://puppet.example.com/nagios3/' },
		],
		
		/ *
		# This is taken from the /etc/apache2/conf-available/nagios3.conf script
		scriptaliases => [
			{
				alias => '/cgi-bin/nagios3',
				path => '/usr/lib/cgi-bin/nagios3',
			},
			{
				alias => '/nagios3/cgi-bin',
				path => '/usr/lib/cgi-bin/nagios3',
			},
		],
		aliases => [
			{	
				alias => '/nagios3/stylesheets',
				path => '/etc/nagios3/stylesheets',
			},
			{
				alias => '/nagios3',
				path => '/usr/share/nagios3/htdocs',
			},
		],
		directories => [
			{
				'path' => '
			},
		]
		* /
	}
	*/
	
	# Install PHP (needed by Nagios)
	class {'::apache::mod::php':
		# Defaults are good for us
		#require => Class['::apache'], # Obviously, mod dependencies are automatically resolved correctly by ::apache
	}
	
	/*
	# Install Proxy mod (needed for proxy passes)
	class {'::apache::mod::proxy':
		#proxy_requests => 'On',
		#allow_from => 'all',
	}
	*/
	
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