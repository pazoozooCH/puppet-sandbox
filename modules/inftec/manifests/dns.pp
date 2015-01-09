# Set up DNS server using ajjahn/dns module
class inftec::dns {
	include dns::server
	
	# Forwarders (Google DNS)
	dns::server::options { '/etc/bind/named.conf.options':
		forwarders => [ '8.8.8.8', '8.8.4.4' ]
	}

	# Forward Zone
	dns::zone { $domain:
		soa         => "ns1.${domain}",
		soa_email   => "admin.${domain}",
		nameservers => ['ns1']
	}
	
	# Helper function to define a-records based on hiera hash-array (not sure if we could handle that smoother...)
	define processA(
		$keys,
	) {
		$aRecord = $keys[$name]
		$myZone = $aRecord['zone']
		$data = $aRecord['data']
		#fail("${zone}")
		dns::record::a { $name:
			zone => "${aRecord['zone']}",
			data => "${aRecord['data']}",
		}
	}
	
	# Load A records (domain name to IP mappings) from hiera classes
	$aRecords = hiera_hash('inftec::dns::a-records')
	$aRecordKeys = keys($aRecords)
	processA { $aRecordKeys : 
		keys => $aRecords,
	}

	/*
	# A Records (domain name to IP mappings)
	dns::record::a {
		'ns1':
			zone => 'example.com',
			data => ['172.16.32.10'];
		'c1a':
			zone => 'example.com',
			data => ['172.16.32.11'];
	}
	
	# CNAME records (domain name aliases)
	dns::record::cname { 'c1cname':
		zone => 'example.com',
		data => 'c1a.example.com',
	}
	dns::record::cname { 'nagios':
		zone => 'example.com',
		data => 'puppet.example.com',
	}
	dns::record::cname { 'wiki':
		zone => 'example.com',
		data => 'puppet.example.com',
	}
	*/
	
	# Open firewall port
	firewall { '210 allow dns access':
		port => [53],
		proto => udp,
		action => accept,
	}
}