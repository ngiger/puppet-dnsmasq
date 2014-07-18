# Copyright 2014, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class 
class dnsmasq::ltsp(
    $tftp_root    = '/var/lib/tftpboot/',
    $root_path    = '/opt/ltsp/i386',
    $boot_params  = 'ltsp/i386/pxelinux.0,server,192.168.1.1',
    $pxe_service  = 'X86PC, "Boot thinclient from network (x2go)", /pxelinux, 192.168.1.1',
) {
  
  if ($include_thinclient) {
    package{ ['atftpd', 'tftpd', 'tftpd-hpa']:  ensure => absent }

    # When running under docker: work around for problem net_server setting capabilities failed: Operation not permitted
    # see: http://stackoverflow.com/questions/23012273/setting-up-docker-dnsmasq
    exec { "/etc/dnsmasq.d/user_root":
      command => '/bin/echo "user=root" >> /etc/dnsmasq.d/user_root',
      unless  => '/usr/bin/test -e /.dockerenv && /usr/bin/test -f /etc/dnsmasq.d/user_root',
      require => [File['/etc/dnsmasq.d'], Package['dnsmasq'] ],
    }

    file { "/etc/dnsmasq.d/thinclient":
      mode => 0644,
#      notify => Runit::Service['dnsmasq'],
      require => [File['/etc/dnsmasq.d'], Package['dnsmasq'] ],
      content => "# $managed_note

# Configures dnsmasq for PXE client booting.
# Log lots of extra information about DHCP transactions.
log-dhcp

dhcp-option=17,$root_path

# Disable re-use of the DHCP servername and filename fields as extra
# option space. That's to avoid confusing some old or broken DHCP clients.
dhcp-no-override

# Set the boot filename depending on the client vendor identifier.
# The boot filename is relative to tftp-root.
dhcp-boot=$boot_params

# The known types are x86PC, PC98, IA64_EFI, Alpha, Arc_x86,
# Intel_Lean_Client, IA32_EFI, BC_EFI, Xscale_EFI and X86-64_EFI
pxe-service=$pxe_service

# Comment the following to disable the TFTP server functionality of dnsmasq.
enable-tftp

# The TFTP directory. Sometimes /srv/tftp is used instead.
tftp-root=$tftp_root

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

