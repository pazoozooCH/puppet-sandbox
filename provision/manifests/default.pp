#
# site.pp - defines defaults for vagrant provisioning
#

# use run stages for minor vagrant environment fixes
stage { 'pre': before => Stage['main'] }

# class { 'repos':   stage => 'pre' }
class { 'vagrant': stage => 'pre' }

# Set up puppet master on master host
if $hostname == 'master' {
	# Set up puppetmaster
	class { 'puppet::server': 
		before => Class['puppet::client'],
	} ->
	
	# Provision librarian-puppet to handle puppet modules from puppet forge
	class { 'puppet::librarian': }
}

# Set up puppet host on all nodes
host {"puppet.${domain}":
	ensure => present,
	comment => 'Puppet master name defaults to puppet: https://docs.puppetlabs.com/guides/install_puppet/post_install.html#get-the-masters-names-and-certificates-set-up',
	host_aliases => ['puppet'],
	ip => '172.16.32.10',
} ->

# Configure and run puppet client on all nodes
class { 'puppet::client': }
