
class txtcmdr::secure(
  $base_dir = '/tmp',
  $base_name = 'mailserver',
  $days = 3650,
) inherits txtcmdr::params{

  require openssl

  $ssl_defaults = {
    base_name => $txtcmdr::secure::base_name,
    base_dir  => $txtcmdr::secure::base_dir,
  }

  openssl::certificate::x509{ $base_name:
    ensure       => present,
    country      => 'PH',
    organization => 'Applester Dev\'t. Corporation',
    unit         => 'Computing Division',
    commonname   => $fqdn,
    base_dir     => $txtcmdr::secure::base_dir,
    days         => $txtcmdr::secure::days,
  }

  define credential( $extension, $target, $base_dir, $base_name, $parameter ){
    $source  = "${base_dir}/${base_name}.${extension}"
    file{ $title:
      path    => $target,
      ensure  => present,
      source  => $source,
      owner   => 'root',
      group   => 'postfix',
      mode    => 640,
      require => Openssl::Certificate::X509[ $base_name ],
    } 
    ->
    exec{ "unlink ${title}": command => "unlink ${source}"}
  } 

  create_resources(credential, $ssl_data, $ssl_defaults)
}

