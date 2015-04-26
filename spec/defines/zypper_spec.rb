require 'spec_helper'

describe 'pe_repo::zypper' do

  let(:title) { 'Suse' }
  let(:pre_condition) {["
        include pe_repo
        service { 'pe-httpd': ensure => running }
      "]}
  let(:facts) {{
      :operatingsystem => 'SLES',
      :osfamily => 'Suse'
  }}
  context "when using default parameters" do
    let(:params) {{
        :pever => '3.7',
        :arch => 'x86_64',
        :dist => 'SLES',
        :rel => '5',
    }}
    it { should compile.with_all_deps }
    it { should contain_exec('pe_repo_download_installerforSuse').with_environment([]) }
  end
  context "when using proxy parameter" do
    proxy = 'http://foo.bar'
    let(:params) {{
        :pever => '3.7',
        :arch => 'x86_64',
        :dist => 'SLES',
        :rel => '5',
        :proxy => proxy,
    }}
    it { should contain_exec('pe_repo_download_installerforSuse').with_environment("[\"HTTP_PROXY=#{proxy}\", \"HTTPS_PROXY=#{proxy}\"]") }
  end
end
