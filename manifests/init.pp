class scripts {

  file { "/usr/local/scripts":
    ensure => directory,
    owner => "root",
    group => "root",
    mode  => 755,
  }

}