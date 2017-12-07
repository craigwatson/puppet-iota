class iota::service {

  file { '/etc/systemd/system/iota.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('iota/systemd.erb'),
    require => File["${::iota::user_home}/node/iota.ini"],
    notify  => Exec['iota_systemctl_daemon_reload'],
  }

  exec { 'iota_systemctl_daemon_reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
    require     => File['/etc/systemd/system/iota.service'],
    notify      => Service['iota'],
  }

  service { 'iota':
    ensure  => $::iota::service_ensure,
    enable  => $::iota::service_enable,
    require => [Exec['iota_systemctl_daemon_reload'],Archive["/home/iota/node/iri-${::iota::version}.jar"]],
  }
}
