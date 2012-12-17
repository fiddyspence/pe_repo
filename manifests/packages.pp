class pe_repo::packages {

  package { 'createrepo':
    ensure => present,
  }

}
