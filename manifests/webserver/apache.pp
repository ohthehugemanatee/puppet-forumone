class forumone::webserver::apache {
  include '::forumone::php'
  
  class { '::apache':
    default_vhost => false,
    mpm_module    => false,
    sendfile      => 'Off',
    user          => $::puppet_user,
    group         => $::puppet_group
  }

  class { 'apache::mod::prefork':
    startservers        => $::forumone::webserver::apache_startservers,
    minspareservers     => $::forumone::webserver::apache_minspareservers,
    maxspareservers     => $::forumone::webserver::apache_maxspareservers,
    serverlimit         => $::forumone::webserver::apache_serverlimit,
    maxclients          => $::forumone::webserver::apache_maxclients,
    maxrequestsperchild => $::forumone::webserver::apache_maxrequestsperchild,
  }

  class { 'php::mod_php5':
  }

# Remove nginx if it's installed
  include '::nginx::params'

  package { $::nginx::params::package:
    ensure => purged,
  }

  service { $::nginx::params::service:
    enable    => false,
    ensure    => false
  }
}
