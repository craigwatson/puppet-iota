class iota::config {

  file { "${::iota::user_home}/node":
    ensure  => directory,
    owner   => $::iota::user_name,
    group   => $::iota::group_name,
    mode    => '0700',
    require => [User[$::iota::user_name],Group[$::iota::group_name]]
  }

  file { "${::iota::user_home}/node/iota.ini":
    ensure  => file,
    owner   => $::iota::user_name,
    group   => $::iota::group_name,
    mode    => '0600',
    require => File["${::iota::user_home}/node"],
    content => template('iota/iota.ini.erb'),
    notify  => Service['iota'],
  }

}
