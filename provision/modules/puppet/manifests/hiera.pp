# Set up Hiera data lookup and test data

class puppet::hiera {
	# Copy hieradata folder
	file { '/etc/puppet/hieradata':
		ensure  => directory,
		source  => 'puppet:///modules/puppet/hieradata',
		recurse => true,
		purge => true,
		owner   => 'puppet',
		group   => 'puppet',
		mode    => '0644',
		replace => true,
	} ->
	# Copy hiera config to /etc/puppet, replace if necessary
	file { '/etc/puppet/hiera.yaml':
		ensure  => present,
		source  => 'puppet:///modules/puppet/hiera.yaml',
		replace => true,
	} ->
	# Make symbolic link to /etc/hiera.yaml so we can use the hiera command without explicitly specifying a config file
	file { '/etc/hiera.yaml':
		ensure  => link,
		target  => '/etc/puppet/hiera.yaml',
		owner   => 'puppet',
		group   => 'puppet',
		mode    => '0644',
	} 
}
