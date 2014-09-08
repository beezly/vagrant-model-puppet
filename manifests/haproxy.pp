if versioncmp($::puppetversion, '3.6.1') >= 0 {

  $allow_virtual_packages = hiera('allow_virtual_packages',false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

class {'haproxy': }

haproxy::listen {'puppet00':
  collect_exported => false,
  ipaddress => $::ipaddress,
  ports => '8140',
}
