require 'spec_helper'

describe 'dnsmasq' do
  let(:facts) { WheezyFacts }

  context 'when running with default parameters' do
    let(:hiera_config) { }
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_dnsmasq }
    it { should_not create_package('dnsmasq') }
    it { should_not create_service('dnsmasq')  }
  end

  context 'when running with ensure true' do
    let(:hiera_config) { }
    let(:params) { { :ensure => 'true',}}
    it { should compile }
    it { should compile.with_all_deps }
    it { should create_class('dnsmasq')}
    it { should_not create_package('dnsmasq') }
    it { should_not create_service('dnsmasq')  }
  end

  context 'when running with ensure true and wakeonlan' do
    let(:hiera_config) { 'spec/fixtures/hiera/hiera2.yaml' }
    it { should compile }
    it { should compile.with_all_deps }
    it { should create_class('dnsmasq')}
    it { should_not create_package('dnsmasq') }
    it { should_not create_service('dnsmasq')  }
    it { should create_package('wakeonlan') }
    it { should contain_file('/etc/ethers').with_content(/^22:22:22:22:22:22            wakeonlan # 192.169.1.1/) }
  end

  context 'when running with ensure ans is_dnsmasq_server true' do
    let(:hiera_config) { }
    let(:params) { { :ensure => 'true', :is_dnsmasq_server => true}}
    it { should compile }
    it { should compile.with_all_deps }
    it { should create_class('dnsmasq')}
    it { should create_package('dnsmasq') }
    it { should create_service('dnsmasq').with({ :ensure => 'running'} )  }
  end

  context 'when running with ensure absent' do
    let(:params) { { :ensure => 'absent' } }
    it { should compile }
    it { should compile.with_all_deps }
    it { should create_package('dnsmasq').with({ :ensure => 'absent'} ) }
    it { should_not create_service('dnsmasq')  }
  end
end
