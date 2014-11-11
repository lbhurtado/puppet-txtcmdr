require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'txtcmdr' do

  let(:title) { 'txtcmdr' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test minimal installation' do
    it { should contain_package('txtcmdr').with_ensure('present') }
    it { should contain_file('txtcmdr.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('txtcmdr').with_ensure('1.0.42') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true } }
    it 'should remove Package[txtcmdr]' do should contain_package('txtcmdr').with_ensure('absent') end 
    it 'should remove txtcmdr configuration file' do should contain_file('txtcmdr.conf').with_ensure('absent') end
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true} }
    it { should contain_package('txtcmdr').with_noop('true') }
    it { should contain_file('txtcmdr.conf').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "txtcmdr/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
    it 'should generate a valid template' do
      content = catalogue.resource('file', 'txtcmdr.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'txtcmdr.conf').send(:parameters)[:content]
      content.should match "value_a"
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet:///modules/txtcmdr/spec"} }
    it { should contain_file('txtcmdr.conf').with_source('puppet:///modules/txtcmdr/spec') }
  end

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/txtcmdr/dir/spec" , :source_dir_purge => true } }
    it { should contain_file('txtcmdr.dir').with_source('puppet:///modules/txtcmdr/dir/spec') }
    it { should contain_file('txtcmdr.dir').with_purge('true') }
    it { should contain_file('txtcmdr.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "txtcmdr::spec" } }
    it { should contain_file('txtcmdr.conf').with_content(/rspec.example42.com/) }
  end

end
