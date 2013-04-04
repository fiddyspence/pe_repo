define pe_repo::yumrepo (
  $pever,
  $arch,
  $dist,
  $rel,
  $url = $::pe_repo::url,
  $defaultfile = $::pe_repo::defaultfile,
){

  $the_target = "${pe_repo::vardir}/${title}"
  $the_file = inline_template("<%= @defaultfile.gsub('DIST',@dist).gsub('ARCH',@arch).gsub('REL',@rel).gsub('PEVER',@pever) -%>")
  $url_real = inline_template("<%= @url.gsub('DIST',@dist).gsub('ARCH',@arch).gsub('REL',@rel).gsub('PEVER',@pever)-%><%=@the_file -%>")
  $the_directory = inline_template("<%= @the_target -%>/<%= @the_file.gsub('.tar.gz$','') -%>")

  file { "${pe_repo::vardir}/${name}":
    ensure => directory,
  } ->
  exec { "pe_repo_download_installerfor${title}":
    command => "curl '${url_real}' -o ${the_target}/${the_file} --insecure -C -",
    creates => "${the_target}/${the_file}",
    path    => '/bin:/usr/bin:/usr/bin/local',
    timeout => 0,
  } ~>
  exec { "unpackinstallerfor${title}":
    command => "tar -zxvf ${the_target}/${the_file}",
    cwd     => $the_target,
    path    => '/bin:/usr/bin:/usr/bin/local',
    creates => $the_directory,
  } ~>
  exec { "createrepofor${title}":
    command => "createrepo .",
    cwd     => "${the_directory}/packages",
    path    => '/bin:/usr/bin:/usr/bin/local',
    creates => "${the_directory}/packages/repodata/",
  } ->
  file { "/etc/puppetlabs/httpd/conf.d/${name}.conf":
    ensure  => present,
    content => template("${module_name}/conf.erb"),
    notify  => Service['pe-httpd'],
  }

}
