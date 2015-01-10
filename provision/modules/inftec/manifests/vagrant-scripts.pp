# Class to install helper scripts on Vagrant machines to quickly execute puppet scripts on Vagrant machines
class inftec::vagrant-scripts {
	file {'/home/vagrant/bin':
		ensure => directory,
		source => 'puppet:///modules/inftec/vagrant-scripts',
		recurse => true,
		purge => true,
		mode => '0500',
		
	} ->
	
	# Create some symlinks for faster execution
	file {'/home/vagrant/bin/pap':
		ensure => link,
		target => '/home/vagrant/bin/puppetApply'
	}
}