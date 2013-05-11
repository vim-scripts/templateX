# installation tasks
class __puppet_fqcn__ {

  Package {  ensure => installed }
  package {
    [
      $__puppet_class__::packages,
      '__puppet_class__',
    ]:
  }
}
