#
# site.pp - defines defaults for vagrant provisioning
#

# use run stages for minor vagrant environment fixes
stage { 'pre': before => Stage['main'] }

# class { 'repos':   stage => 'pre' }
class { 'vagrant': stage => 'pre' }

# class { 'puppet': }
class { 'puppet::client': }
class { 'networking': }

if $hostname == 'puppet' {
	# Set up puppetmaster
	class { 'puppet::server': 
		require => Class['networking'],
		before => Class['puppet::client'],
	} ->
	
	# Provision librarian-puppet to handle puppet modules from puppet forge
	class { 'puppet::librarian': }
}
