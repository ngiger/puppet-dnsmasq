# Copyright 2014, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class
  notify{ "dnsmasq top": }

class dnsmasq (
	$ensure             = false,
  $is_dnsmasq_server  = false,
  $include_wakeonlan  = false,
  $include_thinclient = false,
  $managed_note       = 'Managed by puppet (https://github.com/ngiger/puppet-dnsmasq)',
  $add2conf           = [], # additional lines to be added to the dnsmasq configuration file
  $running_as_docker  = false, # set it to true if you run inside a docker container
) {
      notify{"dnsmasq line 17 $ensure and $is_dnsmasq_server": }
	if ($ensure and $ensure != absent) {
  if ($is_dnsmasq_server) {
    ensure_packages(['dnsmasq-base', 'dnsmasq'])
    if ( $running_as_docker == false) {
      file { "/etc/hosts":
        mode => 0644,
        content => template("dnsmasq/hosts.erb"),
      }
    }
    if false {
      # tried to run under docker, but failed for the moment (July 2014)
# Open problems
# http://stackoverflow.com/questions/19414543/how-can-i-make-etc-hosts-writable-by-root-in-a-docker-container?lq=1
      # using runit
    ensure_packages(['runit'])
    file {'/etc/dnsmasq.d/foreground':
      content => 'keep-in-foreground', # needed to run under daemontools
      require => [File['/etc/dnsmasq.d'], Package['dnsmasq'] ],
    }
    daemontools::service {'dnsmasq':
      ensure  => running,
      command => '/usr/sbin/dnsmasq --keep-in-foreground --pid-file --enable-dbus',
      logpath => '/var/log/dnsmasq',
      require => [File['/etc/dnsmasq.d/foreground', "/etc/dnsmasq.d/$hostname"], Package['dnsmasq']],
    }
    } elsif false { # using daemontools for docker


      file { "/etc/service/dnsmasq": ensure  => directory, require => Package['dnsmasq'], }
      file { "/etc/service/dnsmasq/run":
        content  => "/usr/sbin/dnsmasq --keep-in-foreground --pid-file --enable-dbus --CONFIG_DIR=/etc/dnsmasq.d\n",
        require => File["/etc/service/dnsmasq"],
        mode => 0755,
      }
#      runit::service { 'dnsmasq':
#        user  => 'root',
#        group => 'root',
#      }
    } else { # default debian without runit
        service{  'dnsmasq':
          require => Package['dnsmasq'],
          ensure => running,
          hasstatus => true,
          hasrestart => true,
          enable => true,
        }
      }
    file { "/etc/dnsmasq.d":
      ensure  => directory,
      require => Package['dnsmasq'],
    }
    file { "/etc/dnsmasq.d/$hostname":
      content => template("dnsmasq/dnsmasq.erb"),
      require => [File['/etc/dnsmasq.d'], Package['dnsmasq'] ], # provides DHCP-server
      backup => false,
#      notify => Daemontools::Service ['dnsmasq'],
    }
  } else {
    notify{"dnsmasq ensure absent line 79": }
    package{ 'dnsmasq': ensure => absent, }
  }
	}


}
# vim: ts=2 et sw=2 autoindent

