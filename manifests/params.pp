# Class: txtcmdr::params
#
# This class defines default parameters used by the main module class txtcmdr
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to txtcmdr class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class txtcmdr::params {

  ### Application related parameters

  $config_dir = $::operatingsystem ? {
    default => '/etc/txtcmdr',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/txtcmdr/txtcmdr.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $postfix_map_template = '/etc/txtcmdr/map.erb'
  $postfix_db_init_sql = '/etc/txtcmdr/postfix.sql'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $version = 'present'
  $absent = false
  $audit_only = false
  $noops = false

}
