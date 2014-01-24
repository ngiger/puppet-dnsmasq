# Copyright 2011, niklaus.giger@member.fsf.org
#
# This program is free software; you can redistribute it and/or modify it 
# under the terms of the GNU General Public License version 3 as published by
# the Free Software Foundation.class 


class dnsmasqplus(
  $is_dnsmasq_server  = hiera('dnsmasq::ensure', 'false'),
  $include_wakeonlan  = hiera('dnsmasq::wakeonlan', 'false'),
  $include_thinclient = hiera('dnsmasq::thinclient', 'false'),
) {
  $managed_note       = 'Managed by puppet (https://github.com/ngiger/puppet-dnsmasqplus)'
  
  if ($is_dnsmasq_server) {
    package{ 'dnsmasq': ensure => present, }
    service{ 'dnsmasq': ensure => running, require => Package['dnsmasq'] }
    file { "/etc/dnsmasq.d/$hostname":
      content => template("dnsmasqplus/dnsmasq.erb"),
      require => Package['dnsmasq'], # provides DHCP-server
      backup => false,
    }
    # hiera_include('classes')
    file { "/etc/hosts":
      mode => 0644,
      content => template("dnsmasqplus/hosts.erb"),
    }

  } else {
    package{ 'dnsmasq': ensure => absent, }
    service{ 'dnsmasq': ensure => absent, }
  }

  if ($include_wakeonlan) {
    package{ 'wakeonlan': ensure => present, }
    file { "/etc/ethers":
      mode => 0644,
      content => template("dnsmasqplus/ethers.erb"),
    }
  } else {
    package{ 'wakeonlan': ensure => absent, }
  }
  if ($include_thinclient) {
    package{ ['atftpd', 'tftpd', 'tftpd-hpa']:  ensure => absent }
    $tftp_root    = hiera('dnsmasq::tftp_root',   '/var/lib/tftpboot/')
    $root_path    = hiera('dnsmasq::root_path',   '/opt/ltsp/i386')
    $boot_params  = hiera('dnsmasq::boot_params', 'ltsp/i386/pxelinux.0,server,192.168.1.1')
    $pxe_service  = hiera('dnsmasq::pxe_service', 'X86PC, "Boot thinclient from network (x2go)", /pxelinux, 192.168.1.1')

    file { "/etc/dnsmasq.d/thinclient":
      mode => 0644,
      notify => Service['dnsmasq'],
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

