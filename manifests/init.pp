class scripts {

  file { "/usr/local/scripts/public/":
    ensure => directory,
    owner => "root",
    group => "root",
    mode  => 755,
  }

}