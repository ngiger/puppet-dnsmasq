require 'spec_helper'

describe 'dnsmasq' do
  let(:facts) { WheezyFacts }

  context 'when running with default parameters' do
    let(:hiera_config) { }
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_dnsmasq }
#    it { should_not create_package('dnsmasq') }
  end

  context 'when running with ensure true' do
    let(:hiera_config) { }
    let(:params) { { :ensure => 'true',}}
    it { should compile }
    it { should compile.with_all_deps }
    it { should create_class('dnsmasq')}
    it { should create_package('dnsmasq') }
    it { should_not create_service('dnsmasq')  }
#    it { should create_service('dnsmasq').with({ :ensure => 'running'} )  }
  end

  context 'when running with ensure absent' do
    let(:params) { { :ensure => 'absent' } }
    it { should compile }
    it { should compile.with_all_deps }
    it { should_not create_package('dnsmasq') }
  end
end
