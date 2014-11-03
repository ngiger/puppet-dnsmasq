require 'spec_helper'

describe 'dnsmasq::x2go_tce' do
  let(:facts) { WheezyFacts }
  context 'when running with default parameters for tce' do
    let(:hiera_config) { }
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_dnsmasq__x2go_tce }
#    it { should_not create_package('dnsmasq') }
  end

  context 'when running with parameters for tce' do
    let(:hiera_config) { }
    let(:params) { {  :ensure       => 'true',
                      :tftp_root    => 'test_tftp_root',
                      :x2go_tce_root=> 'test_x2go_tce_root',
                      :boot_params  => 'test_boot_params',
                      :pxe_service  => 'test_pxe_service',
                     }}
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_dnsmasq__x2go_tce }
    it { should create_class('dnsmasq')}
    it { should create_package('dnsmasq') }
    it { should create_service('dnsmasq')  }
    it { should create_service('dnsmasq').with({ :ensure => 'running'} )  }
    it { should contain_file('/etc/dnsmasq.d/x2go_tce').with_content(/^pxe-service=test_pxe_service$/) }
    it { should contain_file('/etc/dnsmasq.d/x2go_tce').with_content(/^dhcp-no-override$/) }
    it { should contain_file('/etc/dnsmasq.d/x2go_tce').with_content(/^dhcp-option=17,test_x2go_tce_root$/) }
    it { should contain_file('/etc/dnsmasq.d/x2go_tce').with_content(/^dhcp-boot=test_boot_params$/) }
    it { should contain_file('/etc/dnsmasq.d/tftpd').with_content(/^enable-tftp$/) }
    it { should contain_file('/etc/dnsmasq.d/tftpd').with_content(/^tftp-root=\/srv\/tftpd$/) }
    it { should contain_file('/etc/hosts').with_content(/^192.168.192.168 fully.qualified.domain.com fully$/) }
  end

  context 'when running with ensure false  for tce' do
    let(:params) { { :ensure => 'false' } }
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_dnsmasq__x2go_tce }
    it { pending('Why is the dnsmasq package present?')
         should create_package('dnsmasq').with( { :ensure => 'absent'} ) }
  end
end
