node default {

  if $facts['os']['family'] == 'RedHat' {
    include ::epel
    Package['jq'] {
      require => Yumrepo['epel'],
    }
  }

  package { 'jq':
    ensure => present,
  }

  class { '::iota':
    version          => '1.4.1.2',
    java_opts        => '-Djava.net.preferIPv4Stack=true',
    neighbors        => [
      'udp://eir.vikingserv.net:15600',
      'udp://hel.vikingserv.net:15600'
    ],
    remote_limit_api => [
      'removeNeighbors',
      'addNeighbors',
      'interruptAttachingToTangle',
      'attachToTangle',
      'getNeighbors'
    ],
  }
}
