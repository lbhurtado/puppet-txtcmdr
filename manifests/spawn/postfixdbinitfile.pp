define txtcmdr::spawn::postfixdbinitfile{

  require txtcmdr

  file {'postfix.sql':
    ensure  => $txtcmdr::manage_file,
    path    => "${txtcmdr::config_dir}/${title}",
    mode    => $txtcmdr::config_file_mode,
    owner   => $txtcmdr::config_file_owner,
    group   => $txtcmdr::config_file_group,
    require => File[$txtcmdr::config_dir],
    source  => 'puppet:///modules/txtcmdr/postfix.sql',
    audit   => $txtcmdr::manage_audit,
    noop    => $txtcmdr::bool_noops,
  }
}
