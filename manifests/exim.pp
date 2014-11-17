
class txtcmdr::exim(
  $absent  = params_lookup( 'absent' ),
  $package = params_lookup( 'exim_package' ),
) inherits txtcmdr::params {

  $bool_absent=any2bool($absent)
  
  $manage_package = $txtcmdr::bool_absent ? {
    true  => 'absent',
    false => $txtcmdr::version,
  }

  package { $txtcmdr::exim_package:
    ensure => $txtcmdr::manage_package,
  }
}
