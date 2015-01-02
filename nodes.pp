#
# nodes.pp - defines all puppet nodes
#

# self-manage the puppet master server
node 'puppet.example.com' {
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
}

node 'client2.example.com' { }
