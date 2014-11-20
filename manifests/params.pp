
class txtcmdr::params(
	$accounts = [],
	$passwords = {},
	$domains = [ "domain.tld" ],
	$vmail_maildir = "/home/vmail",
	$vmail_uid = 4000,
	$vmail_gid = 4000,
	$passwd_source = "",
	$passwd_content = "",
	$aliases_source = "",
	$aliases_content = "",
	$postmaster_address = "postmaster@$fqdn",
	$ssl_cert_content = "",
	$ssl_key_content = "",
	$ssl_ca_content = "",
	$sender_access_content = nil,
	$recipient_access_content = nil,
	$relayto = "",
){
  $exim_package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'exim4',
    default => 'exim',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/txtcmdr',
  }

  $postfix_db_init_sql = $::operatingsystem ? {
    default => '/etc/txtcmdr/postfix.sql',
  }

#  $postfix_sql = 'puppet:///modules/txtcmdr/postfix.sql'

  $version = 'present'
  $absent  = false
}
