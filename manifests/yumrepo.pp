# repo url
# https://pm.puppetlabs.com/cgi-bin/download.cgi?ver=latest&dist=el&arch=x86_64&rel=5
# --no-check-certificate
# https://s3.amazonaws.com/pe-builds/released/2.7.0/puppet-enterprise-2.7.0-ubuntu-12.04-amd64.tar.gz
define pe_repo::yumrepo (
  $url = 'https://s3.amazonaws.com/pe-builds/released/PEVER/',
  $defaultfile = 'puppet-enterprise-PEVER-DIST-REL-ARCH.tar.gz',
  $pever,
  $arch,
  $dist,
  $rel,
)  {

  $the_target = "${pe_repo::vardir}/${title}"
  $the_file = inline_template("<%= @defaultfile.gsub('DIST',@dist).gsub('ARCH',@arch).gsub('REL',@rel).gsub('PEVER',@pever) -%>")
  $url_real = inline_template("<%= @url.gsub('DIST',@dist).gsub('ARCH',@arch).gsub('REL',@rel).gsub('PEVER',@pever)-%><%=@the_file -%>")
  $the_directory = inline_template("<%= @the_target -%>/<%= @the_file.gsub('.tar.gz','') -%>")
#  notify { $the_directory: }
  file { "${pe_repo::vardir}/${name}":
    ensure => directory,
  } ->
  exec { "pe_repo_download_installerfor${title}":
    command => "curl '${url_real}' -o ${the_target}/${the_file} --insecure -C -",
    creates => "${the_target}/${the_file}",
    path => '/bin:/usr/bin:/usr/bin/local',
    timeout => 0,
  } ~>
  exec { "unpackinstallerfor${title}":
    command => "tar -zxvf ${the_target}/${the_file}",
    cwd     => $the_target,
    path => '/bin:/usr/bin:/usr/bin/local',
    creates => $the_directory,
  } ~>
  exec { "createrepofor${title}":
    command => "createrepo .",
    cwd     => "${the_directory}/packages",
    path => '/bin:/usr/bin:/usr/bin/local',
    creates => "${the_directory}/packages/repodata/",
  } ->
  file { "/etc/puppetlabs/httpd/conf.d/${name}.conf":
    ensure => present,
    content => template("${module_name}/conf.erb"),
    notify => Service['pe-httpd'],
  }
#
}
