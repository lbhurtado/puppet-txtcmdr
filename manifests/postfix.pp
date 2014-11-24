
class txtcmdr::postfix(
  $mynetworks = "127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128",
  $aliases_content = $txtcmdr::params::aliases_content,
  $aliases_source = $txtcmdr::params::aliases_source,
  $domains = $txtcmdr::params::domains,
  $ssl_cert_content = $txtcmdr::params::ssl_cert_content,
  $ssl_key_content = $txtcmdr::params::ssl_key_content,
  $ssl_ca_content = $txtcmdr::params::ssl_ca_content,
  $recipient_access_content = $txtcmdr::params::recipient_access_content,
  $sender_access_content = $txtcmdr::params::sender_access_content,
  $maximal_queue_lifetime = "10d",
  $message_size_limit = "50000000",
  $initdb = $txtcmdr::params::postfix_db_init_sql,  
) inherits txtcmdr::params{

  package{ 'postfix': 
    ensure => present,
  }

  package{ 'postfix-mysql': 
    ensure  => present,
    require => Package[ 'postfix' ],
  }

  service { 'postfix':
    enable     => true,
    ensure     => running,
    hasrestart => true,
    require    => Package[ 'postfix' ],
    subscribe  => [
      File [ 'main.cf'  ], 
      File [ 'master.cf' ], 
    ],
  }

  file { 'postfix.sql':
    path    => $txtcmdr::postfix::initdb,
    content => template( 'txtcmdr/postfix/postfix.sql.erb' ), 
    require => Package[ 'postfix' ],
  }

  mysql::db{ $postfix_db:
    user        => $txtcmdr::postfix::mysql_user,
    password    => $txtcmdr::postfix::mysql_password,
    host        => $txtcmdr::postfix::mysql_host,
    grant       => $txtcmdr::postfix::mysql_grant,
    sql         => $txtcmdr::postfix::initdb,
    enforce_sql => true,
    require     => File[ $txtcmdr::postfix::initdb ],
  }
  ->
  exec{ 'unlink postfix.sql':
    command => "unlink ${txtcmdr::postfix::initdb}",
  }

  create_resources( 
    txtcmdr::postfix::mysqlmap, 
    $txtcmdr::postfix::mysql_mappings, 
    $txtcmdr::postfix::mysql_mappings_defaults
  )

  file { 'main.cf':
    path    => '/etc/postfix/main.cf', 
    content => template( 'txtcmdr/postfix/main.cf.erb' ), 
    require => [ 
      Class  [ 'mysql::server'   ], 
      Class  [ 'txtcmdr::secure' ], 
      Package[ 'postfix'         ],
    ],
  }

  file { 'master.cf':
    path    => '/etc/postfix/master.cf',
    content => template( 'txtcmdr/postfix/master.cf.erb' ), 
    require => [ 
      Class  [ 'mysql::server' ], 
      Package[ 'postfix'       ], 
    ],
  }

  if defined( Class[ 'txtcmdr::dovecot' ] ) { 
    if $aliases_source {
      file{ '/etc/aliases-dovecot':
        source => $aliases_source,
      }
    } else {
      file{ '/etc/aliases-dovecot':
	content => $aliases_content,
      }
    }
    exec{ '/usr/sbin/postmap /etc/aliases-dovecot':
      refreshonly => true,
      subscribe   => File[ '/etc/aliases-dovecot' ],
      notify      => Service[ 'postfix' ],
    }
  }

/************* ssl key/certificate *************/ 
  if $ssl_key_content and $ssl_cert_content {

    $enable_ssl = true

    file { '/etc/ssl/certs/postfix-ca.crt':
      content => $ssl_ca_content,
      owner   => 'root',
      group   => 'postfix',
      mode    => 640,
      notify  => Service[ 'postfix' ],
    }

    file { '/etc/ssl/certs/postfix.crt':
      content => $ssl_cert_content,
      owner   => 'root',
      group   => 'postfix',
      mode    => 640,
      notify  => Service[ 'postfix' ],
    }

    file { '/etc/ssl/private/postfix.key':
      content => $ssl_key_content,
      owner   => 'root',
      group   => 'postfix',
      mode    => 640,
      notify  => Service[ 'postfix' ],
    }
  } else {

    $enable_ssl = false

  }
/************* ssl key/certificate *************/ 

/************* /etc/postfix/transport *************/ 
/*
  file { '/etc/postfix/transport':
    content => template( 'txtcmdr/postfix/transport' ), 
    require => Package[ 'postfix' ],
  }

  exec{ '/usr/sbin/postmap hash:/etc/postfix/transport':
    refreshonly => true,
    subscribe   => File[ '/etc/postfix/transport' ],
    notify 	=> Service[ 'postfix' ],
  }
*/
/************* /etc/postfix/transport *************/ 

/************* sender access content  *************/ 
/*
  if $sender_access_content {
    file{ '/etc/postfix/sender_access':
      content => $sender_access_content,
      require => Package[ 'postfix' ],
    }
    exec{ '/usr/sbin/postmap hash:/etc/postfix/sender_access':
      refreshonly => true,
      subscribe   => File[ '/etc/postfix/sender_access' ],
      notify      => Service[ 'postfix' ],
    }
  }
*/
/************* sender access content  *************/ 

/************* recipient access content  *************/ 
/*
  if $recipient_access_content {
    file{ '/etc/postfix/recipient_access':
      content => $recipient_access_content,
      require => Package[ 'postfix' ],
    }
    exec{ '/usr/sbin/postmap hash:/etc/postfix/recipient_access':
      refreshonly => true,
      subscribe   => File[ '/etc/postfix/recipient_access' ],
      notify      => Service[ 'postfix' ],
    }
  }
*/
/************* recipient access content  *************/ 

  cron{ 'google-aspmx-ipv4-fix':
    command => 'for d in aspmx.l.google.com alt1.aspmx.l.google.com alt2.aspmx.l.google.com alt3.aspmx.l.google.com alt4.aspmx.l.google.com aspmx2.googlemail.com aspmx3.googlemail.com aspmx4.googlemail.com aspmx5.googlemail.com ; do sed -i "/$d/d" /etc/hosts ; echo $(dig $d A +short) $d  >> /etc/hosts; done',
    user    => 'root',
    minute  => '0',
  }
}
