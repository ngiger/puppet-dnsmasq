require 'spec_helper'

describe 'dnsmasq::wakeonlan' do
  let(:facts) { WheezyFacts }
  context 'when running with default parameters for wakeonlan' do
    let(:hiera_config) { }
    it {
      should compile
      should compile.with_all_deps
      should contain_dnsmasq__wakeonlan
      should_not create_package('dnsmasq')
    }
  end

  context 'when running with parameters' do
    let(:params) { {  :ensure       => 'true',
                     }}
    it {
      should compile
      should compile.with_all_deps
      should contain_dnsmasq__wakeonlan
      should_not create_class('dnsmasq')
      should_not create_package('dnsmasq')
      should_not create_service('dnsmasq').with({ :ensure => 'running'} )
      should_not contain_file('/etc/dnsmasq.d/ltsp')
      should_not contain_file('/etc/dnsmasq.d/wakeonlan')
  }
  end

  context 'when running with ensure false' do
    let(:params) { { :ensure => 'false' } }
    it {
     should compile
     should compile.with_all_deps
     should contain_dnsmasq__wakeonlan
    }
  end
end
