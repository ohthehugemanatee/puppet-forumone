class forumone ($ports = [80, 443, 8080, 8081, 18983, 8983, 3306, 13306, 1080, 4444, 5555],) {
  case $::operatingsystem {
    /(?i:redhat|centos)/ : {
      class { 'forumone::os::fedora::project': }
    }
  }
  
  group { $::puppet_group:
    ensure  => present,
    gid     => $::host_gid
  }

  user { 'vagrant':
    ensure  => present,
    uid     => $::host_uid,
    groups  => [ $::puppet_group ],
    require => Group[$::puppet_group]
  }

  file { "/vagrant":
    ensure  => "directory",
    owner   => 'vagrant',
    group   => $::puppet_group,
    require => User['vagrant']
  }

  # Vagrant cachier directory
  file { "/tmp/vagrant-cache":
    ensure  => "directory",
    owner   => 'vagrant',
    group   => $::puppet_group,
    require => User['vagrant']
  }


  file { "/home/vagrant/.bashrc":
    ensure  => present,
    owner   => "vagrant",
    group   => "vagrant",
    mode    => "644",
    content => template("forumone/bashrc.erb"),
  }

  create_resources('forumone::solr::collection', hiera_hash('forumone::solr::collections', {
  }
  ))
  
  create_resources('forumone::database::database', hiera_hash('forumone::databases', {
  }
  ))
}
