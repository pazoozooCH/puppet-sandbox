# Install the puppet client and run the deamon
class puppet {

  package { 'puppet':
    ensure => present,
  } ->
  # required to start client agent on ubuntu
  exec { 'start_puppet':
    command => '/bin/sed -i /etc/default/puppet -e "s/START=no/START=yes/"',
    onlyif  => '/usr/bin/test -f /etc/default/puppet',
  } ->
  service { 'puppet':
    enable  => true,
    ensure  => running,
    require => Package[ 'puppet' ],
  }

}
