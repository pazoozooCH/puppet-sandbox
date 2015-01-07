class nagios::service {
 /*
    exec { 'fix-permissions':
        command     => "find /etc/nagios4/conf.d -type f -name '*cfg' | xargs chmod +r",
        refreshonly => true,
    } ->
 */
    
	# TODO: Configure password...
	exec { 'nagios-password':
		command     => "/usr/bin/htpasswd -bc /etc/nagios3/htpasswd.users nagiosadmin password",
		unless => "/usr/bin/htpasswd -bv /etc/nagios3/htpasswd.users nagiosadmin password",
	}
	
    service { 'nagios3':
        ensure      => running,
        enable      => true,
        require     => Class[ 'nagios::install' ], 
    }
}