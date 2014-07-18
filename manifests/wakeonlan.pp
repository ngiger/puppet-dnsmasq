# Copyright 2014, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class 

class dnsmasq::wakeonlan(
  $ensure = true,
) {
  include dnsmasq
  if $ensure {
    notify{"Ensure  wakeonlan $managed_note":}
    package{ 'wakeonlan': ensure => present, }
    file { "/etc/ethers":
      mode => 0644,
      content => template("dnsmasq/ethers.erb"),
    }
  } else {
    notify{"Remove wakeonlan":}
    package{ 'wakeonlan': ensure => absent, }
  }
}
# vim: ts=2 et sw=2 autoindent

