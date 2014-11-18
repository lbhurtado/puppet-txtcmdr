
class txtcmdr::noexim(
  $absent  = params_lookup( 'absent' ),
  $package = params_lookup( 'exim_package' ),
) inherits txtcmdr::params {

  $bool_absent=any2bool($absent)
  
  $manage_package = $txtcmdr::noexim::bool_absent ? {
    false => 'absent',
    true  => $txtcmdr::params::version,
  }

  package { $package:
    ensure => $txtcmdr::noexim::manage_package,
  }
  
}
