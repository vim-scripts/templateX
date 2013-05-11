# parameters
class __puppet_fqcn__ {

  case $::osfamily {
    'Debian': {
      $packages = ['__puppet_class__']
    }
    'Suse': {
      $packages = ['__puppet_class__']
    }
    'RedHat': {
      $packages = ['__puppet_class__']
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
