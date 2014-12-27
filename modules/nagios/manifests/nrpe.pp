# Nagios Client

class nagios::nrpe {
 
    package { [ 'nagios-nrpe-server', 'nagios-plugins' ]:
        ensure      => present,
    }
 
    service { 'nagios-nrpe-server':
        ensure      => running,
        enable      => true,
        require     => Package[ 'nagios-nrpe-server', 'nagios-plugins' ],
    }
}