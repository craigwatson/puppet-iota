class iota (
  String $version,
  Array $neighbors,
  Integer           $api_port         = 14800,
  String            $api_host         = '127.0.0.1',
  Optional[Integer] $udp_port         = 14600,
  Optional[Integer] $tcp_port         = 15600,
  Optional[String]  $send_limit       = undef,
  Array             $remote_limit_api = [],
  Integer           $max_peers        = 0,
  Boolean           $testnet          = false,
  Boolean           $rescan_db        = false,
  Boolean           $debug            = false,
  String            $ixi_dir          = 'ixi',
  String            $db_path          = 'db',
  String            $user_name        = 'iota',
  String            $group_name       = 'iota',
  String            $user_home        = '/home/iota',
  String            $service_ensure   = 'running',
  Boolean           $service_enable   = true,
  Integer           $java_ram_mb      = floor(($::memory['system']['total_bytes'] * 0.9)/1048576),
  Optional[String]  $java_opts        = undef,
) {

  include ::java

  $all_neighbors = join($neighbors,' ')
  $all_remote_limit_api = join($remote_limit_api, ',')

  include ::iota::account
  include ::iota::install
  include ::iota::config
  include ::iota::service

}
