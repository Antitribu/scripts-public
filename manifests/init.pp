class scriptspublic {

  file { "/usr/local/scripts/public/":
    owner 	=> "root",
    group 	=> "root",
    mode  	=> 775,
  	purge   => true,
  	recurse => true,
  	force   => true,
  	ensure  => present,
  	ignore  => ".svn",
  	source => "puppet:///modules/scriptspublic/default/$kernel"
  }
}