define nagios::client::default(
	$address,
	$cfgFile = "/etc/nagios3/conf.d/$name.cfg",
) {
	nagios_host { $name:
		target => $cfgFile,
		#mode => '0644', # Not available in puppet 3.4...
		ensure => present,
		alias => $name,
		address => $address,
		use => 'generic-host',
		require => Class['nagios'],
		notify => Service['nagios3'],
	}
	
	# Set mode of config file (in puppet 3.7, we could set the mode parameter, but that's not available for puppet 3.4...)
	file { $cfgFile:
		mode => '0644',
		require => Nagios_host[ $name ],
	}
}