# Copyright 2014, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class

class dnsmasq::tftp(
  $ensure    = false,
  $tftp_root = '/srv/tftpd',
) {
  include dnsmasq
  if ($ensure) {
    if !defined(Class['dnsmasq']) {class{'dnsmasq':  ensure => $ensure, is_dnsmasq_server => $ensure} }
    file { "/etc/dnsmasq.d/tftpd":
      mode => 0644,
      require => [ Package['dnsmasq'] ],
      notify => [Service['dnsmasq']],
      content => "# $::dnsmasq::managed_note
# Comment the following to disable the TFTP server functionality of dnsmasq.
enable-tftp

# The TFTP directory. Sometimes /srv/tftp is used instead.
tftp-root=$tftp_root
",
    }
  }
}
# vim: ts=2 et sw=2 autoindent

