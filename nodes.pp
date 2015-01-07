#
# nodes.pp - defines all puppet nodes
#

# Load default firewall rules for all nodes
node basenode {
	# Purge non-managed (IPv4) firewall rules
	resources { 'firewall':
		purge => true,
	}

	# Load default firewall rules
	class { 'inftec::firewall::default': }
}

# self-manage the puppet master server
node 'puppet.example.com' inherits basenode {
	# Open puppet port
	firewall { '150 allow puppet access':
		port => 8140,
		proto => tcp,
		action => accept,
	}

  # Configure the DNS server
  class { 'inftec::dns': }
  
  # Configure SSL
  class { 'inftec::ssl': }
  
  # Configure the DNS client
  class { 'inftec::dns-client':
	nameserver => '172.16.32.10',
	domain => 'example.com',
  }

  # Configure Apache
  class { 'inftec::apache':
  }
  
  # Nagios Server
  class { 'nagios': }
  
  # VPN Server
  class { 'inftec::vpn': }
  
  # LDAP Server
  # class { 'inftec::ldap': }
  
  # Add client1 host (manually, i.e. not with exported resources...)
  nagios::client::default{'client1':
    address => '172.16.32.11',
  }
  
  # Monitor client2
  nagios::client::default{'client2':
    address => '172.16.32.12',
  }
}

##### CLIENTS

node 'client1.example.com' {
  class { 'helloworld': }
  class { 'helloworld::hiera': 
    hieraMsg2 => "Mandatory parameter",
  }
  
  # Nagios Client
  class { 'nagios::nrpe':}
  
  # Configure the DNS client
  class { 'inftec::dns-client':
	nameserver => '172.16.32.10',
	domain => 'example.com',
  }
  
  # Install and configure Docker
  class { 'inftec::docker::client1': }
}

node 'client2.example.com' { }
