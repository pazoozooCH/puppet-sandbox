# Set up SSL files for testing
class inftec::ssl {
	package{'openssl':
		ensure => present,
	}
	
	# For testing purposes, we'll copy test certificates from the git repo that we've created manually
	file{'/etc/ssl/certs/ssl-cert-test.pem':
		source => '/vagrant/ssl/test-creation/test-alt.pem',
		ensure => present,
		mode => '644',
		owner => 'root',
		group => 'root',
		require => Package['openssl'],
	}
	file{'/etc/ssl/private/ssl-cert-test.key':
		source => '/vagrant/ssl/test-creation/test-alt.key',
		ensure => present,
		mode => '640',
		owner => 'root',
		group => 'ssl-cert',
		require => Package['openssl'],
	}
	
	# Copy the test CA certificate - not sure if this is actually necessary...
	file{'/etc/ssl/certs/ssl-caert-test.pem':
		source => '/vagrant/ssl/test-creation/root-ca.pem',
		ensure => present,
		mode => '644',
		owner => 'root',
		group => 'root',
		require => Package['openssl'],
	}
}