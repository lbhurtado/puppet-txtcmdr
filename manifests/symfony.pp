define txtcmdr::symfony(
    $path = '/vagrant'
) {

  file { $path: ensure  => directory }

  exec { 'install symfony':
    command     => 'composer --prefer-dist --no-interaction create-project symfony/framework-standard-edition ./',
    cwd         => "$path",
    environment => ['COMPOSER_HOME=/usr/bin/', 'COMPOSER_PROCESS_TIMEOUT=4000'],
    creates     => "$path/web",
    timeout     => 0,
    require     => File[$path],
  }

}