# Class to start the puppet service. We'll expect puppet to be present, otherwise we couldn't run this script...
class puppet::client {

  service { 'puppet':
    enable  => true,
    ensure  => running,
  }

}
