class puppet::server {
  package { 'puppetmaster':
    ensure => present,
  }

  /*
  package { 'puppet-lint':
    ensure   => latest,
    provider => gem,
  }
  */

  file { 'puppet.conf':
    path    => '/etc/puppet/puppet.conf',
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
    source  => 'puppet:///modules/puppet/puppet.conf',
    require => Package[ 'puppetmaster' ],
    notify  => Service[ 'puppetmaster' ],
  }

  file { 'site.pp':
    path    => '/etc/puppet/manifests/site.pp',
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
    source  => 'puppet:///modules/puppet/site.pp',
    require => Package[ 'puppetmaster' ],
  }

  file { 'autosign.conf':
    path    => '/etc/puppet/autosign.conf',
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
    content => '*',
    require => Package[ 'puppetmaster' ],
  }

  file { '/etc/puppet/manifests/nodes.pp':
    ensure  => link,
    target  => '/vagrant/nodes.pp',
    require => Package[ 'puppetmaster' ],
  }

  service { 'puppetmaster':
    enable => true,
    ensure => running,
	require => [
	  File['/etc/puppet/manifests/nodes.pp', '/etc/puppet/hiera.yaml'],
	  Package['puppetmaster'],
	],
  }
  
  # Hiera configuration
  
  # Copy hiera config to /etc/puppet, replace if necessary
  file { '/etc/puppet/hiera.yaml':
    ensure  => present,
	source  => '/vagrant/hiera.yaml',
	replace => true,
	require => File['/etc/puppet/hieradata'],
  }
  # Make symbolic link to /etc/hiera.yaml so we can use the hiera command without explicitly specifying a config file
  file { '/etc/hiera.yaml':
    ensure  => link,
	target  => '/etc/puppet/hiera.yaml',
	owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
	require => File['/etc/puppet/hiera.yaml'],
  }
  
  # Copy hieradata folder
  file { '/etc/puppet/hieradata':
    ensure  => directory,
	source  => '/vagrant/hieradata',
	recurse => true,
	owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
	replace => true,
  }

}
