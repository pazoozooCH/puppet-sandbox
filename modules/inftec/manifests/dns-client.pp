# Configure DNS client on Ubuntu

class inftec::dns-client(
	$nameserver,
	$domain,
) {
	# Use the head file (instead of base) for the nameserver  as eth0 will already have a nameserver entry in /run/resolveconf/interface/eth0.dhclient
	file {'/etc/resolvconf/resolv.conf.d/head':
		content => template('inftec/resolv.conf.head.erb'),
		notify => Exec['resolvconf'],
	}
	
	# The domain can be entered in the base file
	file {'/etc/resolvconf/resolv.conf.d/base':
		content => template('inftec/resolv.conf.base.erb'),
		notify => Exec['resolvconf'],
	}
	
	exec {'resolvconf':
		command => '/sbin/resolvconf -u',
		refreshonly => true,
	}
}