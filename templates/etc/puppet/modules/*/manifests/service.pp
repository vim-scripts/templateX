# service tasks
class __puppet_fqcn__ {

  service { '__puppet_class__':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
