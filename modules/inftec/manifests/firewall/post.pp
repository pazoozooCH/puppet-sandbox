# Firewall post settings
# Drop everything not explicitly allowed (whitelist)

class inftec::firewall::post {
  firewall { '999 drop all':
    proto   => 'all',
    action  => 'drop',
    before  => undef,
  }
}