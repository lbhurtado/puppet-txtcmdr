
define txtcmdr::postfix::map ($maps) {

  file { $title:
    ensure  => present,
    path    => $title,
    group   => 'postfix',
    mode    => 'u=rw,g=r,o=',
    require => Package [ 'postfix' ],
    content => template ( 'txtcmdr/postfix/map.erb' ), 
  }

  exec { "postmap-${title}":
    command     => "/usr/sbin/postmap ${title}",
    require     => Package['postfix'],
    subscribe   => File[$title],
    refreshonly => true,
  }

}
