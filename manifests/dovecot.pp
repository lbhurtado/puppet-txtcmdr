
class txtcmdr::dovecot (
  $sasl = true,

  $accounts = $txtcmdr::params::accounts,
  $passwords = $txtcmdr::params::passwords,

  $vmail_maildir = $txtcmdr::params::vmail_maildir,
  $vmail_uid = $txtcmdr::params::vmail_uid,
  $vmail_gid = $txtcmdr::params::vmail_gid,

  $passwd_content = $txtcmdr::params::passwd_content,
  $passwd_source = $txtcmdr::params::passwd_source,
  $postmaster_address = $txtcmdr::params::postmaster_address,

  $ssl_cert_content = $txtcmdr::params::ssl_cert_content,
  $ssl_key_content = $txtcmdr::params::ssl_key_content,
  $ssl_ca_content = $txtcmdr::params::ssl_ca_content,

  $enable_sieve = true,
  $enable_quota = false,

) inherits txtcmdr::params {

  user { 'vmail':
    uid  => $vmail_uid,
    gid  => $vmail_gid,
    home => $vmail_maildir,
  }
	
  group { 'vmail':
    gid => $vmail_gid,
  }
	
  file{ $vmail_maildir:
    ensure => directory,
    owner  => 'vmail',
    group  => 'vmail',
    mode   => 'u+w',
  }

  if $accounts {
    file{ '/etc/dovecot/passwd':
      content => template( 'txtcmdr/dovecot/passwd.erb' ),
      mode   => 640,
      owner  => dovecot,
      group  => dovecot,
    }
  } else {
    if $passwd_source {
      file{ '/etc/dovecot/passwd':
        source => $passwd_source,
        mode   => 640,
        owner  => dovecot,
        group  => dovecot,
      }
    } else {
      file { '/etc/dovecot/passwd':
        content => $passwd_content,
        mode    => 640,
        owner   => dovecot,
	group   => dovecot,
      }
    }
  }

  package { 'dovecot-imapd': ensure => present }
  
  package { 'dovecot-managesieved': ensure => present }
  
  service { 'dovecot':
    enable     => true,
    ensure     => running,
    hasrestart => true,
    require    => Package[ 'dovecot-imapd' ],
    subscribe  => [
      File[ '/etc/dovecot/conf.d/99-puppet.conf' ],
      File[ '/etc/dovecot/passwd' ],
    ],
  }
  
  if defined( 'txtcmdr::postfix' ) {
    if $sasl { $enable_sasl_postfix = true }
  }

  if $ssl_key_content and $ssl_cert_content {
    $enable_ssl = true
    
    file { '/etc/ssl/certs/dovecot-ca.crt':
      content => $ssl_ca_content,
      owner   => 'root',
      group   => 'dovecot',
      mode    => 640,
      notify  => Service[ 'dovecot' ],
    }
    
    file{ '/etc/ssl/certs/dovecot.crt':
      content => $ssl_cert_content,
      owner   => 'root',
      group   => 'dovecot',
      mode    => 640,
      notify  => Service[ 'dovecot' ],
    }

    file{ '/etc/ssl/private/dovecot.key':
      content => $ssl_key_content,
      owner   => 'root',
      group   => 'dovecot',
      mode    => 640,
      notify  => Service[ 'dovecot' ],
    }
  }

  file { '/etc/dovecot/conf.d/99-puppet.conf':
    content => template( 'txtcmdr/dovecot/99-puppet.conf.erb' ),
  }

  file { '/etc/dovecot/conf.d/10-auth.conf':
    content => template( 'txtcmdr/dovecot/10-auth.conf.erb' ),
  }

  file { '/etc/dovecot/conf.d/auth-sql.conf.ext':
    content => template( 'txtcmdr/dovecot/auth-sql.conf.ext.erb' ),
  }

  file { '/etc/dovecot/conf.d/10-mail.conf':
    content => template( 'txtcmdr/dovecot/10-mail.conf.erb' ),
  }

  file { '/etc/dovecot/conf.d/10-master.conf':
    content => template( 'txtcmdr/dovecot/10-master.conf.erb' ),
  }

  file { '/etc/dovecot/conf.d/10-ssl.conf':
    content => template( 'txtcmdr/dovecot/10-ssl.conf.erb' ),
  }

  file { '/etc/dovecot/conf.d/15-lda.conf':
    content => template( 'txtcmdr/dovecot/15-lda.conf.erb' ),
  }

  file { '/etc/dovecot/dovecot-sql.conf.ext':
    content => template( 'txtcmdr/dovecot/dovecot-sql.conf.ext.erb' ),
  }

}
