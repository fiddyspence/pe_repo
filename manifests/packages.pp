# == Class: pe_repo
#
# Class container to manage the required packages for the pe_repo module
#
class pe_repo::packages {

  case $::osfamily {
    'Debian', 'RedHat': {
      $pkglist = ['createrepo', 'dpkg-devel']
    }
    'Suse': {
      $pkglist = 'createrepo'
    }
  }
  package { $pkglist:
    ensure => present,
  }

}
