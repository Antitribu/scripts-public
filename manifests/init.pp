class scriptspublic {
  
  $kernel_downcase = downcase($kernel)

  file { "/usr/local/scripts/public/":
    owner 	=> "root",
    group 	=> "root",
    mode  	=> 0775,
  	purge   => true,
  	recurse => true,
  	force   => true,
  	ensure  => present,
  	ignore  => ".svn",
  	source  => "puppet:///modules/scriptspublic/default/$kernel_downcase"
  }
}