
define txtcmdr::postfix::mysqlmap(
  $filename,
  $user,
  $password,
  $hosts,
  $dbname,
  $query,
  ) {

  txtcmdr::postfix::map {$filename:
    maps => {
      user     => $user,
      password => $password,
      hosts    => $hosts,
      dbname   => $dbname,
      query    => $query,
    },
    require    => Class['mysql::server'],
  }
}
