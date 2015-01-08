class puppet::server {
	
	# Execute the following steps in order
	
	# Install Puppetmaster
	package { 'puppetmaster':
		ensure => present,
	} ->
	file { 'puppet.conf':
		path    => '/etc/puppet/puppet.conf',
		owner   => 'puppet',
		group   => 'puppet',
		mode    => '0644',
		source  => 'puppet:///modules/puppet/puppet.conf',
		#notify  => Service[ 'puppetmaster' ],
	} ->
	
	# Create site.pp file
	file { 'site.pp':
		path    => '/etc/puppet/manifests/site.pp',
		owner   => 'puppet',
		group   => 'puppet',
		mode    => '0644',
		source  => 'puppet:///modules/puppet/site.pp',
	} ->
	file { 'autosign.conf':
		path    => '/etc/puppet/autosign.conf',
		owner   => 'puppet',
		group   => 'puppet',
		mode    => '0644',
		content => '*',
	} ->
	file { '/etc/puppet/manifests/nodes.pp':
		ensure  => link,
		target  => '/vagrant/nodes.pp',
		require => Package[ 'puppetmaster' ],
	} ->
	
	# Set up Hiera
	class {'hiera':
	} ->
	
	# Finally, start the puppetmaster service
	service { 'puppetmaster':
		enable => true,
		ensure => running,
		subscribe => File ['/etc/puppet/hiera.yaml'],
	}
}
