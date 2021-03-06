
class txtcmdr (
  $config_dir          = params_lookup( 'config_dir' ),
  $absent              = params_lookup( 'absent' ),
  $postfix_db_init_sql = params_lookup( 'postfix_db_init_sql' ),
  ) inherits txtcmdr::params {

  $bool_absent=any2bool($absent)

  $manage_file = $txtcmdr::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  file { 'txtcmdr.dir':
    ensure  => directory,
    path    => $txtcmdr::config_dir,
  }

}
