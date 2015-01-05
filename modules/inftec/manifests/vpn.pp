# Set up an OpenVPN server
class inftec::vpn {
	openvpn::server { 'main':
		country      => 'CH',
		province     => 'BE',
		city         => 'Winterthur',
		organization => 'inftec.ch',
		email        => 'admin@inftec.ch',
		local        => '172.16.32.10',
		server       => '10.200.200.0 255.255.255.0',
	}
	
	openvpn::client { 'client1':
		server => 'main',
	}
}