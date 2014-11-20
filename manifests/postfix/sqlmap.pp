
define txtcmdr::postfix::sqlmap (
  $sqlmap_user     = 'mailuser',    
  $sqlmap_password = 'mailpassword',    
  $sqlmap_hosts    = '127.0.0.1',    
  $sqlmap_dbname   = 'mailserver',    
  $sqlmap_query,    
  $postconf_key,
) {

  txtcmdr::postfix::map {$title:
    maps => {
      user     => $sqlmap_user,
      password => $sqlmap_password,
      hosts    => $sqlmap_hosts,
      dbname   => $sqlmap_dbname,
      query    => $sqlmap_query,
    }
  }

  if $postconf_key {
    txtcmdr::postfix::postconf{ $postconf_key:
      value => $title 
  }

  }
}
