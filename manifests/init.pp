class scriptspublic {
  
  $kernel_downcase = inline_template('<%= kernel.downcase %>')

  file { "/usr/local/scripts/":
    owner   => "root",
    group   => "root",
    mode    => "0775",
    ensure  => "directory",
  }

  file { "/usr/local/scripts/public/":
    owner 	=> "root",
    group 	=> "root",
    mode  	=> "0775",
  	purge   => true,
  	recurse => true,
  	force   => true,
  	ensure  => present,
  	ignore  => ".svn",
  	source  => "puppet:///modules/scriptspublic/default/$kernel_downcase"
  }
}


 
 