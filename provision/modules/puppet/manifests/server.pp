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
	
	# Copy hieradata folder
	file { '/etc/puppet/hieradata':
		ensure  => directory,
		source  => '/vagrant/hieradata',
		recurse => true,
		owner   => 'puppet',
		group   => 'puppet',
		mode    => '0644',
		replace => true,
	} ->
	# Copy hiera config to /etc/puppet, replace if necessary
	file { '/etc/puppet/hiera.yaml':
		ensure  => present,
		source  => '/vagrant/hiera.yaml',
		replace => true,
	require => File['/etc/puppet/hieradata'],
	} ->
	# Make symbolic link to /etc/hiera.yaml so we can use the hiera command without explicitly specifying a config file
	file { '/etc/hiera.yaml':
		ensure  => link,
		target  => '/etc/puppet/hiera.yaml',
		owner   => 'puppet',
		group   => 'puppet',
		mode    => '0644',
		require => File['/etc/puppet/hiera.yaml'],
	} ->
	# Finally, start the puppetmaster service
	service { 'puppetmaster':
		enable => true,
		ensure => running,
	}
}
