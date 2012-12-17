class pe_repo::files {

  file { $pe_repo::vardir:
    ensure  => directory,
    owner   => $settings::user,
    group   => $settings::group,
    mode    => '0644',
    recurse => true,
  }
  file { '/etc/puppetlabs/httpd/conf.d/repo.conf':
    ensure => present,
    source => "puppet:///modules/${module_name}/repo.conf",
    notify => Service['pe-httpd'],
  }
}
