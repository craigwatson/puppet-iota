# puppet-iota

[![Build Status](https://secure.travis-ci.org/craigwatson/puppet-iota.png?branch=master)](http://travis-ci.org/craigwatson/puppet-iota)
[![Puppet Forge](http://img.shields.io/puppetforge/v/CraigWatson1987/iota.svg)](https://forge.puppetlabs.com/CraigWatson1987/iota)

#### Table of Contents

1. [Overview - What is the puppet-iota module?](#overview)
1. [Module Description - What does the module do?](#module-description)
1. [Setup - The basics of getting started with puppet-iota](#setup)
    * [Beginning with puppet-iota](#beginning-with-puppet-iota)
    * [Usage Example](#usage-example)
    * [Advanced Usage](#advanced usage)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

This Puppet module downloads, installs and configures a headless IRI full node for use within the IOTA Tangle.

## Puppet 3 Support

**Please note that the master branch of this module does not support Puppet 3!**

On 31st December 2016, support for Puppet 3.x was withdrawn. As such, this module is not compatible with Puppet 3.

## Module Description

  * Creates a user/group for `iri` to be run with
  * Creates a `INI` configuration file
  * Downloads the pre-compiled JAR file from GitHub
  * Creates, enables and starts an `iota` daemon/service via systemd

## Setup


### Beginning With puppet-iota

You **must** specify - either via Hiera or directly in Puppet - the version of `iri` to download and an `Array` of neighbors to use.

### Java Options

  * The module will ensure the presence of a JRE via the `puppetlabs/java` module.
  * By default, the value of Java's `Xms` and `Xmx` settings will be 90% of available system RAM, expressed in Megabytes. To change this, use the `java_ram_mb` parameter.
  * To set advanced Java options (for example `-Djava.net.preferIPv4Stack=true`), use the `java_opts` parameter.

### Usage Example

To download version 1.4.1.2 of `iri` and manually specify three neighbors:

```puppet
class { '::iota':
  version   => '1.4.1.2',
  neighbors => [
    'udp:://someone.else:15600',
    'tcp://some.other.server:14600',
    'tcp://10.10.10.10:1234',
  ],
}
```

### Advanced Usage

**Note**: setting TCP and UDP port numbers to `undef` will remove them from `iota.ini`

```puppet
class { '::iota':
  testnet          => true,
  debug            => true,
  version          => '1.4.1.2',
  java_ram_mb      => 8192,
  tcp_port         => undef,
  udp_port         => 15600,
  remote_limit_api => [
    'attachToTangle',
    'addNeighbors'
  ],
  neighbors        => [
    'udp:://someone.else:15600',
    'tcp://some.other.server:14600',
    'tcp://10.10.10.10:1234',
  ],
}
```

## Reference

### IRI Configuration Parameters

  * For detailed explanations of the parameters used to configure the `iri` daemon, see here: https://github.com/iotaledger/iri#command-line-options
  * If any configuration options are not managed by the module, please submit a pull request!

### Classes

#### `iota::account`

  * Creates the user and group to use with `iri`

#### `iota::config`

  * Places the daemon configuration

#### `iota::install`

  * Downloads the IRI Java JAR file from GitHub to the `iota` user's home directory
  * Installs the packages necessary to run the headless daemon

#### `iota::service`

  * Deploys systemd configuration files for running the `iota` service
  * Ensures the `iota` service is running

## Limitations

The module does _not_ manage or install any GUI, for example [Nostalgia](https://github.com/domschiener/nostalgia)

### Supported Operating Systems

Versions higher than those listed below _may_ work, but are not tested.

* RHEL/Scientific/CentOS 7
* Debian 8
* Ubuntu 16.04

## Development

* Copyright (C) Craig Watson - <craig@cwatson.org>
* Distributed under the terms of the Apache License v2.0 - see LICENSE file for details.
* The project ships with a working Vagrant environment with boxes configured for each supported OS version.
* Further contributions and testing reports are extremely welcome - please submit a pull request or issue on [GitHub](https://github.com/craigwatson/puppet-iota)
