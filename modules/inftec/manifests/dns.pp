# Set up DNS server using ajjahn/dns module
class inftec::dns (
	$ipDnsServer,
) {
	include dns::server
	
	# Forwarders (Google DNS)
	dns::server::options { '/etc/bind/named.conf.options':
		forwarders => [ '8.8.8.8', '8.8.4.4' ]
	}

	# Forward Zone
	dns::zone { $domain:
		soa         => "ns1.${domain}",
		soa_email   => "admin.${domain}",
		nameservers => ['ns1'],
	}
	
	# A record for name server
	dns::record::a {'ns1':
		zone => "$domain",
		data => "$ipDnsServer",
	}

	
	# Load DNS entries from hiera (see hieradata files, e.g. inftec-vagrant.ch/domain.yaml)
	
	# Helper function to define DNS entries based on hiera hash-array (not sure if we could handle that smoother...)
	define processEntries(
		$entries,
	) {
		$entry = $entries[$name]
		$type = $entry['type']
		
		if $type == 'a' {
			dns::record::a { $name:
				zone => "${entry['zone']}",
				data => "${entry['data']}",
			}
		} elsif $type == 'cname' {
			dns::record::cname { $name:
				zone => "${entry['zone']}",
				data => "${entry['data']}",
			}
		}
	}
	
	# Load A records (domain name to IP mappings) from hiera classes
	$entries = hiera('inftec::dns::entries')
	$entryKeys = keys($entries)
	processEntries { $entryKeys : 
		entries => $entries,
	}

	# Open firewall port
	firewall { '210 allow dns access':
		port => [53],
		proto => udp,
		action => accept,
	}
}