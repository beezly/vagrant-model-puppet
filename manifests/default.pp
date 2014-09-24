if versioncmp($::puppetversion, '3.6.1') >= 0 {

  $allow_virtual_packages = hiera('allow_virtual_packages',false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

hiera_include('classes')

$default_packages = hiera('default_packages')

package {$default_packages: 
	ensure => 'latest',
}

service {'iptables':
  ensure => 'stopped',
  enable => 'false',
}

node 'puppet-ca' {
  
  # Ensure we have correct dependencies for EPEL before we try
  # to install mod_passenger
  
  Class['epel'] -> Package['mod_passenger']
  
  host {'puppetmaster-1':
    ip => '192.168.10.11',
  }
  
  host {'puppetmaster-2':
    ip => '192.168.10.12',
  }
  
  # Setup DNS alt names so that puppet-ca works  
  augeas {"puppet ca dns_alt_names":
    context => '/files/etc/puppet/puppet.conf',
    changes => 'set main/dns_alt_names puppet,puppet-ca',
    require => Package['puppet-server'],
  }
  
	# Enable autosign 
  file {'/etc/puppet/autosign.conf':
		ensure  => 'present',
		owner   => 'root',
		group   => 'root',
		content => '*',
		mode    => '644',
		require => Package['puppet-server'],
		notify  => Service['puppetmaster'],
	}	
	
	service {'puppetmaster':
		ensure  => 'running',
		enable  => 'true',
    require => [Package['puppet-server'],Augeas['puppet ca dns_alt_names'],Host['puppetmaster-1','puppetmaster-2']],
	}
	
}

node /^puppetmaster-\d+$/ {

  Host { ensure => 'present' }
    
  host {'puppet-ca':
    ip => '192.168.10.10',
    host_aliases => 'puppet',
  }
  
	augeas {'puppet ca_server':
  	context => '/files/etc/puppet/puppet.conf',
    changes => 'set main/ca_server puppet-ca',
    notify  => Service['puppetmaster'],
    require => Package['puppet-server'],
  }
  
  augeas {"puppet master dns_alt_names":
    context => '/files/etc/puppet/puppet.conf',
    changes => 'set main/dns_alt_names puppet',
    require => Package['puppet-server'],
    notify  => Service['puppetmaster'],
  }
  
  augeas {'puppet disable ca': 
    context => '/files/etc/puppet/puppet.conf',
    changes => 'set main/ca false',
    require => Package['puppet-server'],
    notify  => Service['puppetmaster'],
  }
  
  package {'puppet-server':
    ensure => 'latest',
  }
  
  # Before we start the puppetmaster we make sure we have valid certs
  
  exec {'puppet acquire ca and local certs':
    path => '/usr/bin:/bin',
    command => 'puppet agent --verbose --onetime --no-daemonize',
    creates => ['/var/lib/puppet/ssl/certs/ca.pem','/var/lib/puppet/ssl/certs/${::fqdn}.pem'],
    before  => Service['puppetmaster'],
  }
  
  service {'puppetmaster':
    ensure  => 'running',
    enable  => 'true',
    require => [Package['puppet-server'],Host['puppet-ca']],
  }
}