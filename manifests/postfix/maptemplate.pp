# = Define: txtcmdr::postfix::maptemplate
# Based on the example42 php module, customised here to match the paths on apache 2.4.6
#
define txtcmdr::postfix::maptemplate ($config_dir = '/etc/txtcmdr') {

  file {"${config_dir}": ensure => directory}

  file {"${config_dir}/${title}":
    ensure  => present,
    source  => 'puppet:///modules/txtcmdr/postfix/map.erb',
    require => File["${config_dir}"],
  }
}
