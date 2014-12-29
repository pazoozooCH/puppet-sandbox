# Set up DNS server using ajjahn/dns module
class inftec::dns {
	include dns::server
	
	# Forwarders (Google DNS)
	dns::server::options { '/etc/bind/named.conf.options':
		forwarders => [ '8.8.8.8', '8.8.4.4' ]
	}

	# Forward Zone
	dns::zone { 'example.com':
		soa         => 'ns1.example.com',
		soa_email   => 'admin.example.com',
		nameservers => ['ns1']
  }
	
	# A Records:
	dns::record::a {
		'ns1':
			zone => 'example.com',
			data => ['172.16.32.10'];
		'c1a':
			zone => 'example.com',
			data => ['172.16.32.11'];
	}
	
	# CNAME records
  dns::record::cname { 'c1cname':
    zone => 'example.com',
    data => 'c1a.example.com',
  }
}