# Class: __puppet_class__
#   Description
#
# == Parameters
#
#   $par1 = ''
#     Description
#
#   $par2
#     val1|val2|val3
#     Description
#
# == Examples
#
#   Description
#
#   include '__puppet_class__'
#   __puppet_class__::add {$::fqdn: }
#   class { '__puppet_class__':
#       par1 => '256MB',
#   }
#
#
class __puppet_class__ (
  $par1 = 'default',__goto__
  ) {

  File {
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }

  anchor { '__puppet_class__::start': }
    -> class { '__puppet_class__::install': }
    -> class { '__puppet_class__::config': }
    -> class { '__puppet_class__::service': }
    -> anchor { '__puppet_class__::end': }

  # Define: add
  #   Example for define
  #
  # == Parameters
  #
  #   $par1
  #     val1|val2|val3
  #     Description
  #
  # == Examples
  #
  #   __puppet_class__::add{'name':
  #     par1 => 'val',
  #   }
  #
  define add ($par1 = 'default') {
    File {
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      notify  => undef,
      require => undef,
    }
    Exec {
      notify  => undef,
      require => undef,
    }
  }
}

class __puppet_class__::install {
  package {
    '__puppet_class__':
      ensure => installed;
  }
}

# configure tasks
class __puppet_class__::config {
}

# services tasks
class __puppet_class__::service {
  service { '__puppet_class__':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}

