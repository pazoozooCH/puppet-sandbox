define nagios::client::default(
	$address,
) {
	$cfgFileBase = "/etc/nagios3/conf.d/$name"
	$cfgFileHost = "${cfgFileBase}.cfg"
	$cfgFileService = "${cfgFileBase}_service.cfg"
	
	nagios_host { $name:
		target => $cfgFileHost,
		#mode => '0644', # Not available in puppet 3.4...
		ensure => present,
		alias => $name,
		address => $address,
		use => 'generic-host',
		require => Class['nagios'],
		notify => Service['nagios3'],
	}
	
	# Set mode of config file (in puppet 3.7, we could set the mode parameter, but that's not available for puppet 3.4...)
	file { [$cfgFileHost, $cfgFileService]:
		mode => '0644',
		require => Nagios_host[ $name ],
	}
	
	nagios_service { $name:
		target => "${cfgFileService}",
		host_name => $name,
		service_description => 'Disk Space',
		check_command => 'check_all_disks!20%!10%',
		use => 'generic-service',
		require => Nagios_host[$name],
	}
}