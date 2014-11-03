# Copyright 2014, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class

# Open problems
# http://stackoverflow.com/questions/19414543/how-can-i-make-etc-hosts-writable-by-root-in-a-docker-container?lq=1
class dnsmasq::x2go_tce(
  $ensure        = false,
  $x2go_tce_root = '/opt/x2gothinclient',
  $log_dhcp = true,
  $boot_params =  'ltsp/i386/pxelinux.0,server,192.168.1.1',
  $pxe_service = 'X86PC, "Boot thinclient from network (x2go)", /pxelinux, 192.168.1.1',
  $tftp_root   = '/srv/tftpd',

)  {
  if ($ensure) {
   if !defined(Class['dnsmasq']) {class{'dnsmasq':  ensure => $ensure, is_dnsmasq_server => $ensure} }
   if !defined(Class['dnsmasq::tftp']) {class{'dnsmasq::tftp':  ensure => $ensure} }

    file { "/etc/dnsmasq.d/x2go_tce":
      mode => 0644,
      require => [Package['dnsmasq'] ],
      content => "# $::dnsmasq::managed_note

dhcp-option=17,$x2go_tce_root

# Disable re-use of the DHCP servername and filename fields as extra
# option space. That's to avoid confusing some old or broken DHCP clients.
dhcp-no-override

# Set the boot filename depending on the client vendor identifier.
# The boot filename is relative to tftp-root.
dhcp-boot=$boot_params

# The known types are x86PC, PC98, IA64_EFI, Alpha, Arc_x86,
# Intel_Lean_Client, IA32_EFI, BC_EFI, Xscale_EFI and X86-64_EFI
pxe-service=$pxe_service

# Kill multicast.
dhcp-option=vendor:pxe,6,2b

# Disable re-use of the DHCP servername and filename fields as extra
# option space. That's to avoid confusing some old or broken DHCP clients.
dhcp-no-override
",
    }
  }
}
# vim: ts=2 et sw=2 autoindent

