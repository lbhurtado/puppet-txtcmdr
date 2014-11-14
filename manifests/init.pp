# = Class: txtcmdr
#
# This is the main txtcmdr class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $txtcmdr_absent
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include txtcmdr"
# - Call txtcmdr as a parametrized class
#
# See README for details.
#
#
class txtcmdr (
  $config_dir          = params_lookup( 'config_dir' ),
  $absent              = params_lookup( 'absent' ),
  $postfix_db_init_sql = params_lookup( 'postfix_db_init_sql' ),

  ) inherits txtcmdr::params {

  $bool_absent=any2bool($absent)

  ### Definition of some variables used in the module
  $manage_file = $txtcmdr::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  ### Managed resources

  file { 'txtcmdr.dir':
    ensure  => directory,
    path    => $txtcmdr::config_dir,
  }

  file { 'postfix.sql':
    ensure  => $txtcmdr::manage_file,
    path    => $txtcmdr::postfix_db_init_sql,
    require => File[ 'txtcmdr.dir' ],
  }

}
