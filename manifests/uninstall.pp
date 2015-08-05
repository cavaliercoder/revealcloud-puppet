# Private class: copperegg::uninstall
#
# Copyright 2012,2013 CopperEgg
#
# Sample Usage:
#
# class{'copperegg': ensure => 'absent' }
#
class copperegg::uninstall {
  Exec {
  	path => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ]
  }

  # paths to delete (recursively)
  $paths = [
    '/tmp/revealcloud',
    '/usr/local/revealcloud',
    '/etc/init/revealcloud.conf',
  	'/etc/init.d/revealcloud',
  	'/etc/rc*.d/*revealcloud',
  	'/home/revealcloud',
  ]
  $paths_string = join($paths, ' ')

  exec { 'stop revealcloud daemon' : 
  	command => "/etc/init.d/revealcloud stop",
  	onlyif  => "ps -axco command | grep ^revealcloud\\\$"
  }

  exec { 'removing revealcloud files' :
    command => "rm -rf ${paths_string}",
    onlyif  => "test -d /usr/local/revealcloud",
    require => Exec['stop revealcloud daemon'],
  }

  exec { 'removing revealcloud user' :
    command => "userdel -rf revealcloud",
    onlyif  => "getent passwd revealcloud",
    require => Exec['stop revealcloud daemon'],
  }
}