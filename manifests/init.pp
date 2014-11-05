class txtcmdr{
  file{'/etc/txtcmdr':
    ensure => directory,
    purge => true,
  }
  
  file{'/etc/txtcmdr/postfix.sql':
    ensure  => present,
    source  => 'puppet:///modules/txtcmdr/postfix/postfix.sql',
    require => File['/etc/txtcmdr'],
  }
  
  file{'/etc/txtcmdr/map.erb':
    ensure  => present,
    source  => 'puppet:///modules/txtcmdr/postfix/map.erb',
    require => File['/etc/txtcmdr'],
  }
}
