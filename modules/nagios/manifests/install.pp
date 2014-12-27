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
    }
}
