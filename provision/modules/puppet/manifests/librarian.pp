# == Class: puppet::librarian
#
# This class installs puppet librarian.
# Couldn't get it running properly - Ruby or Ruby Gem version issues... :-@
#
# === Parameters
#
# === Actions
#
# - Install Puppet server package
# - Install puppet-lint gem
# - Configure Puppet to autosign puppet client certificate requests
# - Configure Puppet to use nodes.pp and modules from /vagrant directory
# - Ensure puppet-master daemon is running
#
# === Requires
#
# === Sample Usage
#
#   class { 'puppet::librarian': }
#
class puppet::librarian {

  package { ['ruby-all-dev'] :
    ensure => installed,
  }
  
  package { ['librarian-puppet'] :
    ensure => installed,
	provider => 'gem'
  }
  
  exec { 'librarian-puppet':
    command => '/usr/local/bin/librarian-puppet install --path=/etc/puppet/modules',
	path => '/vagrant',
	logoutput => true
  }
}
