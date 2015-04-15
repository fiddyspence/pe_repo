require 'spec_helper'

describe 'pe_repo::yumrepo' do

  let(:title) { 'Debian' }
  context "when using default parameters", :compile do
    let(:params) {{
        :pever => '3.7',
        :arch => 'x86_64',
        :dist => 'SLES',
        :rel => '5',
    }}
    it { should compile.with_all_deps }
    it { should contain_exec('pe_repo_download_installerforDebian').with_environment('') }
  end
  context "when using proxy parameter", :compile do
    proxy = 'http://foo.bar'
    let(:params) {{
        :pever => '3.7',
        :arch => 'x86_64',
        :dist => 'SLES',
        :rel => '5',
        :proxy => proxy,
    }}
    it { should contain_exec('pe_repo_download_installerforDebian').with_environment("HTTP_PROXY=#{proxy} HTTPS_PROXY=#{proxy}") }
  end
end
