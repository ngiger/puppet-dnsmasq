require 'spec_helper'

# Look at the file spec/fixtures/hiera/mustermann.yaml to find all values specified
describe 'dnsmasq', :type => :class do
  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
  let(:facts) { WheezyFacts }
  context 'when using mustermann.yaml' do

    let(:params) { { :ensure => "true" } }
    it { should compile }
    it { should compile.with_all_deps }
    it { should_not contain_file('/etc/dnsmasq.d/xg2o_tce') }
    it { should contain_file('/etc/hosts') }
    it { should contain_file('/etc/hosts').with_content(/managed_note mustermann/) }
  end
end

describe 'dnsmasq::ltsp' do
  let(:facts) { WheezyFacts }
  context 'when using mustermann.yaml' do
    let(:params) { { } }
    it { should compile }
    it { should compile.with_all_deps }
    it { should contain_package('dnsmasq') }
    it { should contain_package('atftpd').with({:ensure => 'absent'} ) }
    it { should_not contain_file('/etc/dnsmasq.d/xg2o_tce') }
    it { should contain_file('/etc/dnsmasq.d/ltsp').with_content(/dhcp-boot=ltsp\/i386\/pxelinux.0,mustermann,192.169.1.1/) }
    it { should contain_file('/etc/dnsmasq.d/ltsp').with_content(/dhcp-option=17,\/mustermann\/ltsp\/i386/) }
    it { should contain_file('/etc/dnsmasq.d/ltsp').with_content(/Boot thinclient from network \(x2go\) mustermann/) }
    it { should contain_file('/etc/dnsmasq.d/ltsp').with_content(/managed_note mustermann/) }
    it { should contain_file('/etc/dnsmasq.d/fully').with_content(/managed_note mustermann/) }
#    it { should contain_file('/etc/dnsmasq.d/user_root').with_content(/managed_note mustermann/) }
    it { should contain_file('/etc/dnsmasq.d/tftpd').with_content(/managed_note mustermann/) }
  end
end

describe 'dnsmasq::tftp' do
  let(:facts) { WheezyFacts }
  context 'when using mustermann.yaml' do
    let(:params) { { } }
    it { should compile }
    it { should compile.with_all_deps }
    it { should_not contain_file('/etc/dnsmasq.d/xg2o_tce') }
  end
end

describe 'dnsmasq::verbosity' do
  let(:facts) { WheezyFacts }
  context 'when using mustermann.yaml' do
    let(:params) { { } }
    it { should compile }
    it { should compile.with_all_deps }
    it { should_not contain_file('/etc/dnsmasq.d/xg2o_tce') }
  end
end

describe 'dnsmasq::x2go_tce' do
  let(:facts) { WheezyFacts }
  context 'when using mustermann.yaml' do
    let(:params) { { } }
    it { should compile }
    it { should compile.with_all_deps }
    it { should_not contain_file('/etc/dnsmasq.d/thinclient') }
    it { should contain_file('/etc/dnsmasq.d/x2go_tce').with_content(/dhcp-boot=mustermann/) }
    it { should contain_file('/etc/dnsmasq.d/x2go_tce').with_content(/dhcp-option=17,\/mustermann\/x2gothinclient/) }
    it { should contain_file('/etc/dnsmasq.d/x2go_tce').with_content(/Boot thinclient from network \(x2go\) mustermann/) }
    it { should contain_file('/etc/dnsmasq.d/x2go_tce').with_content(/managed_note mustermann/) }
  end
end
