# Configure firewall settings
# Configuration is inspired by https://forge.puppetlabs.com/puppetlabs/firewall

class inftec::firewall::default {
	# Load pre and post rules in the correct order
	Firewall {
		require => Class['pre'],
		before => Class['post'],
	}
	
	# Make sure pre and post are loaded
	class {['pre', 'post']: }
	
	# Load firewall class
	class {'firewall': }
	
	# Load default application rules
	firewall { '100 allow ssh access':
		port => [22],
		proto => tcp,
		action => accept,
	}
}