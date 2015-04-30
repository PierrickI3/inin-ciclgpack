require 'puppetlabs_spec_helper/module_spec_helper'
require 'spec_helper'

describe 'ciclgpack' do
  let(:title) {'ciclgpack'}

  let(:params) { {:locale => 'fr', :cic_version => '2015_R2'} }
  let(:facts) { { :operatingsystem => 'Windows'} }


  it { is_expected.to create_class('ciclgpack') }
end