class iota::account {
  user { $::iota::user_name:
    ensure     => present,
    comment    => 'Iota Daemon',
    home       => $::iota::user_home,
    managehome => true,
    shell      => '/bin/false',
    gid        => $::iota::group_name,
    require    => Group[$::iota::group_name],
  }

  group { $::iota::group_name:
    ensure => present,
  }
}
