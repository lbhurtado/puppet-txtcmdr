define txtcmdr::symfony(
    $path = '/vagrant'
) {

  file { $path: ensure  => directory }

  exec { "symfony-install":
    command     => "composer --cache-dir=/dev/null --verbose --no-interaction create-project symfony/framework-standard-edition ./",
    cwd         => $path,
    creates     => "${path}/web",
    timeout     => 0,
    require     => File[$path],
  }

}