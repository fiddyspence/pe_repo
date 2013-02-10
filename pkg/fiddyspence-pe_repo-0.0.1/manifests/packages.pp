class pe_repo::packages {

  package { 'createrepo':
    ensure => present,
  }
  package { 'dpkg-devel':
    ensure => present,
  }

}
