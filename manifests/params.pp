
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

  $version = 'present'
  $absent  = false

  $mysql_mappings_defaults = {
    'user'     => 'mailuser',
    'password' => 'mailpassword',
    'hosts'    => '127.0.0.1',
    'dbname'   => 'mailserver',
  }

  $mysql_mappings = {
    'virtual_mailbox_domains' => {
      'filename' => '/etc/postfix/mysql-virtual-mailbox-domains.cf',
      'query'    => 'SELECT 1 FROM virtual_domains WHERE name=\'%s\'',
    },
    'virtual_mailbox_maps' => {
      'filename' => '/etc/postfix/mysql-virtual-mailbox-maps.cf',
      'query'    => 'SELECT 1 FROM virtual_users WHERE email=\'%s\'',
    },
    'virtual_alias_maps' => { 
      'filename' => '/etc/postfix/mysql-virtual-alias-maps.cf',
      'query'    => 'SELECT 1 FROM virtual_aliases WHERE source=\'%s\'',
    },
  }

}
