require 'spec_helper'

describe 'dnsmasq::ltsp' do
  let(:facts) { WheezyFacts }
  context 'when running with default parameters for ltsp' do
    let(:hiera_config) { }
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_dnsmasq__ltsp }
    it { should_not create_package('dnsmasq') }
  end

  context 'when running with parameters' do
    let(:params) { {  :ensure       => 'true',
                      :tftp_root    => 'test_tftp_root',
                      :root_path    => 'test_root_path',
                      :boot_params  => 'test_boot_params',
                      :pxe_service  => 'test_pxe_service',
                     }}
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_dnsmasq__ltsp }
    it { should create_class('dnsmasq')}
    it { should create_package('dnsmasq') }
    it { should create_service('dnsmasq').with({ :ensure => 'running'} )  }
    it { should contain_file('/etc/dnsmasq.d/ltsp').with_content(/^dhcp-no-override$/) }
    it { should contain_file('/etc/dnsmasq.d/ltsp').with_content(/^enable-tftp$/) }
    it { should contain_file('/etc/dnsmasq.d/ltsp').with_content(/^tftp-root=test_tftp_root$/) }
    it { should contain_file('/etc/dnsmasq.d/ltsp').with_content(/^dhcp-option=17,test_root_path$/) }
    it { should contain_file('/etc/dnsmasq.d/ltsp').with_content(/^dhcp-boot=test_boot_params$/) }
    it { should contain_file('/etc/dnsmasq.d/ltsp').with_content(/^tftp-root=test_tftp_root$/) }
  end

  context 'when running with ensure false' do
    let(:params) { { :ensure => 'false' } }
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_dnsmasq__ltsp }
    it { pending('Why is the dnsmasq package present?')
         should create_package('dnsmasq').with( { :ensure => 'absent'} ) }
  end
end
