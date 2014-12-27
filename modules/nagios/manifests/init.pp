class nagios {
    include nagios::install
    include nagios::service
    #include nagios::import
}