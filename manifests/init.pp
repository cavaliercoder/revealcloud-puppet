# Class: copperegg
#
# Copyright 2012,2013 CopperEgg
#
# Sample Usage:
#
# include copperegg
#
# or to override any of the deafaults:
#
# class{'copperegg':  tags => 'tag1, tag2'}
#
class copperegg(
    $ensure = 'present',
    $tags = $copperegg::params::revealCloudTags,
    $api_key = $copperegg::params::revealCloudAPIKey,
    $label = $copperegg::params::revealCloudLabel,
    $uuid = $copperegg::params::revealCloudUUID,
    $OOM_protect = $copperegg::params::revealCloudOomProtect,
    $proxy =   $copperegg::params::revealCloudProxy
  ) inherits copperegg::params {

  include copperegg::params

  # expand $tags if it is an array
  $_tags = is_array($tags) ? {
    true  => join($tags, ','),
    false => $tags,
  }

  case $ensure {
    'present' : {
      include copperegg::install
      
      service { $copperegg::params::revealCloudServiceName:
        ensure     => running,
        #   enable     => true,
        hasstatus => false,
        require => Class[ 'copperegg::install' ],
      }
    }

    'absent' : {
      include ::copperegg::uninstall
    }

    default : { fail("Supported ensure value: ${ensure}") }
  }  
}
