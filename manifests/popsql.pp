define txtcmdr::popsql ($config_dir = '/etc/txtcmdr') {

  require txtcmdr

  file {"${txtcmdr::config_dir}/${title}":
    ensure  => present,
    source  => 'puppet:///modules/txtcmdr/postfix.sql',
    require => File["${$txtcmdr::config_dir}"],
  }
}
