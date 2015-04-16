require 'spec_helper'
describe 'pe_repo' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "pe_repo class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}
        let(:pre_condition) {["
            service { 'pe-httpd': ensure => running }
        "]}
        it { should compile.with_all_deps }
        it { should contain_class('pe_repo') }
        it { should contain_class('pe_repo::packages').that_comes_before('pe_repo::files') }
        it { should contain_class('pe_repo::files') }
        it { should contain_package('createrepo').with_ensure('present') }
        it { should contain_package('dpkg-devel').with_ensure('present') }
      end
    end
  end
  context 'unsupported operating system' do
    describe 'pe_repo class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}
      it { expect { should contain_class('pe_repo') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
