# Set up an OpenVPN server
class inftec::vpn {
	openvpn::server { 'main':
		country      => 'CH',
		province     => 'BE',
		city         => 'Winterthur',
		organization => 'inftec.ch',
		email        => 'admin@inftec.ch',
		server       => '10.200.200.0 255.255.255.0',
	}
}