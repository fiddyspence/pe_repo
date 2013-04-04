# == Class: pe_repo
#
# Full description of class pe_repo here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { pe_repo:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
class pe_repo (
  $vardir = hiera('pe_repo::vardir','/opt/pe_repo'),
  $url = 'https://s3.amazonaws.com/pe-builds/released/PEVER/',
  $defaultfile = 'puppet-enterprise-PEVER-DIST-REL-ARCH.tar.gz'
){
  class { 'pe_repo::packages': } ->
  class { 'pe_repo::files': } ->
  Pe_repo::Yumrepo <| |> ->
  Pe_repo::Dpkg <| |> ->
  Class['pe_repo']
}
