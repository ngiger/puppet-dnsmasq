# Copyright 2014, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class 

# Open problems
# http://stackoverflow.com/questions/19414543/how-can-i-make-etc-hosts-writable-by-root-in-a-docker-container?lq=1
class dnsmasq::verbosity(
    $log_dhcp = false, # # Log lots of extra information about DHCP transactions.
    $log_queries = false,
) {
  include dnsmasq
    if ($log_dhcp or $log_queries) {
    file { "/etc/dnsmasq.d/verbosity":
      mode => 0644,
      require => [File['/etc/dnsmasq.d'], Package['dnsmasq'] ],
      content => "# $dnsmasq::managed_note
log-dhcp
log-queries

"      
    }
  }
}
# vim: ts=2 et sw=2 autoindent

