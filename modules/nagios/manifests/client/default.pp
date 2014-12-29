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
		hostgroups => 'debian-servers,ssh-servers',
		require => Class['nagios'],
		notify => Service['nagios3'],
	}
	
	# Set mode of config file (in puppet 3.7, we could set the mode parameter, but that's not available for puppet 3.4...)
	file { [$cfgFileHost, $cfgFileService]:
		mode => '0644',
		require => Nagios_host[ $name ],
	}
	
	# Define common services
	
	## Disk Space
	nagios_service { "${name}_diskSpace":
		target => "${cfgFileService}",
		host_name => $name,
		service_description => 'Disk Space',
		check_command => 'check_all_disks!20%!10%',
		use => 'generic-service',
		require => Nagios_host[$name],
		notify => Service['nagios3'],
	}
	
	## Current Users
	nagios_service { "${name}_currentUsers":
		target => "${cfgFileService}",
		host_name => $name,
		service_description => 'Current Users',
		check_command => 'check_users!20!50',
		use => 'generic-service',
		require => Nagios_host[$name],
		notify => Service['nagios3'],
	}
	
	## Total Processes
	nagios_service { "${name}_totalProcesses":
		target => "${cfgFileService}",
		host_name => $name,
		service_description => 'Total Processes',
		check_command => 'check_procs!250!400',
		use => 'generic-service',
		require => Nagios_host[$name],
		notify => Service['nagios3'],
	}
	
	## Current Load
	nagios_service { "${name}_currentLoad":
		target => "${cfgFileService}",
		host_name => $name,
		service_description => 'Current Load',
		check_command => 'check_load!5.0!4.0!3.0!10.0!6.0!4.0',
		use => 'generic-service',
		require => Nagios_host[$name],
		notify => Service['nagios3'],
	}
}