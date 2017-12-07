class iota::install {

  if $::iota::testnet == true {
    $download_version = "testnet-v${::iota::version}"
  } else {
    $download_version = "v${::iota::version}"
  }

  archive { "${::iota::user_home}/node/iri-${::iota::version}.jar":
    source  => "https://github.com/iotaledger/iri/releases/download/${download_version}/iri-${::iota::version}.jar",
    require => [File["${::iota::user_home}/node"],Package['java']],
  }

}
