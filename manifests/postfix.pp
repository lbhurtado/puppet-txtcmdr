
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

  file { 'postfix-mysql.dir':
    ensure  => directory,
    path    => '/etc/postfix/mysql',
    require => Package [ 'postfix' ],
  } 

  file { 'mysql_vmail.sql':
    ensure  => present,
    path    => '/etc/postfix/mysql/mysql_vmail.sql',
    require => File [ 'postfix-mysql.dir' ],
    content => template( 'txtcmdr/mysql/mysql_vmail.sql.erb' ), 
  }
  
  file { 'iredmail.mysql':
    ensure  => present,
    path    => '/etc/postfix/mysql/iredmail.mysql',
    require => File [ 'postfix-mysql.dir' ],
    content => template( 'txtcmdr/mysql/iredmail.mysql.erb' ), 
  }

  exec { 'populate mysql database vmail':
    command => "mysql --user=root --password=linux < /etc/postfix/mysql/mysql_vmail.sql && touch /tmp/mysql_vmail_populated",
    require => [
      Class [ 'mysql::server'   ],
      File  [ 'mysql_vmail.sql' ],
      File  [ 'iredmail.mysql'  ],
    ],
    unless => "test -e /tmp/mysql_vmail_populated"
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

  file { 'aliases':
    path    => '/etc/postfix/aliases',
    content => template( 'txtcmdr/postfix/aliases.erb' ), 
    require => Package[ 'postfix' ], 
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

  cron{ 'google-aspmx-ipv4-fix':
    command => 'for d in aspmx.l.google.com alt1.aspmx.l.google.com alt2.aspmx.l.google.com alt3.aspmx.l.google.com alt4.aspmx.l.google.com aspmx2.googlemail.com aspmx3.googlemail.com aspmx4.googlemail.com aspmx5.googlemail.com ; do sed -i "/$d/d" /etc/hosts ; echo $(dig $d A +short) $d  >> /etc/hosts; done',
    user    => 'root',
    minute  => '0',
  }
}
