# Set up an LDAP server
class inftec::ldap {
	# Install and configure server
	class { 'ldap::server':
		suffix  => 'dc=example,dc=com',
		rootdn  => 'cn=admin,dc=example,dc=com',
		rootpw  => sha1digest('pw'), # Password needs to be SHA1 encrypted
	}
	
	# Install client utilities
	package { 'ldap-utils':
		ensure => present,
	}
}