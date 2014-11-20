
class txtcmdr::secure(
  $key  = '/etc/ssl/private/mailserver.pem',
  $cert = '/etc/ssl/certs/mailserver.pem',
  $days = 3650,
) inherits txtcmdr::params{

  require openssl

  openssl::certificate::x509{'mailserver':
    ensure       => present,
    country      => 'PH',
    organization => 'Applester Dev\'t. Corporation',
    unit         => 'Computing Division',
    commonname   => $fqdn,
    base_dir     => '/tmp',
    days         => $days,
  }
    
  file{ $key:
    ensure  => present,
    source  => '/tmp/mailserver.key',
    require => Openssl::Certificate::X509['mailserver'],
  }
  ->
  exec{'rm /tmp/mailserver.key':}
  
  file{ $cert:
    ensure  => present,
    source  => '/tmp/mailserver.crt',
    require => Openssl::Certificate::X509['mailserver'],
  }
  ->
  exec{'rm /tmp/mailserver.crt':}
}

