class {'dnsmasq':
    is_dnsmasq_server => true,
    include_wakeonlan => true,
    include_thinclient => true,
  }
