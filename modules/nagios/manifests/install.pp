# Some info on automated installation: http://blog.bluemalkin.net/automated-nagios-monitoring-with-puppet-exported-resources/

# Nagios will be available at http://localhost/nagios3
# Username / password see service.pp

/*
class nagios::install {
    package { [ 'nagios4', 'nagios-plugins', 'nagios-nrpe-plugin' ]:
        ensure  => present,
    }
}
*/

class nagios::install {
    package { [ 'nagios3', 'nagios-plugins', 'nagios-nrpe-plugin' ]:
        ensure  => present,
    } ->
	
	# Enable external commands (otherwise, we cannot issue commands from the CGI interface like reschedule checks)
	augeas { 'nagios.cfg':
		lens => 'Simplevars.lns',
		incl => '/etc/nagios3/nagios.cfg',
		changes => [
			'set check_external_commands 1',
		],
		notify => Service['nagios3'],
	} ~> # Notify
	
	# We need to fix the file permission in order to be able to use external commands
	exec {'nagios-external-commands':
		refreshonly => true, # We only need to fix the file permissions once (when we adapt the nagios.cfg file)
		command => '/usr/bin/dpkg-statoverride --update --force --add nagios www-data 2710 /var/lib/nagios3/rw && /usr/bin/dpkg-statoverride --update --force --add nagios nagios 751 /var/lib/nagios3 && /bin/chown -R nagios:www-data /var/lib/nagios3/rw',
		#unless => "/usr/bin/test `stat -c '%a' /var/lib/nagios3/rw` = 2710",
	}
}
