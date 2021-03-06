# == Class consul::params
#
# This class is meant to be called from consul
# It sets variables according to platform
#
class consul::params {

  $install_method    = 'url'
  $package_name      = 'consul'
  $package_ensure    = 'latest'
  $ui_package_name   = 'consul_ui'
  $ui_package_ensure = 'latest'
  $version = '0.5.0'

  case $::architecture {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'i386':            { $arch = '386'   }
    default:           {
      fail("Unsupported kernel architecture: ${::architecture}")
    }
  }

  $os = downcase($::kernel)

  if $::operatingsystem == 'Ubuntu' {
    if versioncmp($::lsbdistrelease, '8.04') < 1 {
      $init_style = 'debian'
    } else {
      $init_style = 'upstart'
    }
  } elsif $::operatingsystem =~ /Scientific|CentOS|RedHat|OracleLinux/ {
    if versioncmp($::operatingsystemrelease, '7.0') < 0 {
      $init_style = 'sysv'
    } else {
      $init_style  = 'systemd'
    }
  } elsif $::operatingsystem == 'Fedora' {
    if versioncmp($::operatingsystemrelease, '12') < 0 {
      $init_style = 'sysv'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem == 'Debian' {
    $init_style = 'debian'
  } elsif $::operatingsystem == 'SLES' {
    $init_style = 'sles'
  } elsif $::operatingsystem == 'Darwin' {
    $init_style = 'launchd'
  } elsif $::operatingsystem == 'Amazon' {
    $init_style = 'sysv'
  } else {
    $init_style = undef
  }
  if $init_style == undef {
    fail('Unsupported OS')
  }
}
