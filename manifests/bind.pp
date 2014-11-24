
class txtcmdr::bind(
  $absent  = params_lookup( 'absent' ),
  $package = params_lookup( 'bind_package' ),
) inherits txtcmdr::params {

  $bool_absent=any2bool($absent)
  
  $manage_package = $txtcmdr::bind::bool_absent ? {
    true => 'absent',
    false  => $txtcmdr::params::version,
  }
 
  package { 'bind':
    ensure => installed, 
    name   => $txtcmdr::bind::bind_package,
  }

  service { 'bind':
    ensure     => running,
    name       => 'bind9',
    enable     => true,
    hasstatus  => true,
    pattern    => 'named',
    require    => Package['bind'],
    subscribe  => [
      File [ 'named.conf.local' ],
      File [ 'zone' ],
      File [ 'loopback' ],
    ]
  }
 
  file { 'named.conf.local':
    ensure  => present,
    path    => "/etc/bind/named.conf.local",
    content => template( 'txtcmdr/bind/named.conf.local.erb' ), 
    require => Package [ 'bind' ],
  }
 
  file { 'zone':
    ensure  => present,
    path    => "/etc/bind/txtcmdr.xyz",
    content => template( 'txtcmdr/bind/txtcmdr.xyz.erb' ), 
    require => Package [ 'bind' ],
  }
 
  file { 'loopback':
    ensure  => present,
    path    => "/etc/bind/txtcmdr.xyz.loopback",
    content => template( 'txtcmdr/bind/txtcmdr.xyz.loopback.erb' ), 
    require => Package [ 'bind' ],
  }
 
  file { 'resolv.conf':
    ensure  => present,
    path    => "/etc/resolv.conf",
    content => template( 'txtcmdr/bind/resolv.conf.erb' ), 
  }
 
}
