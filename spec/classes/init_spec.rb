require 'spec_helper'

describe 'ciclgpack' do

  context 'with defaults for all parameters' do
  	let(:facts) { {:operatingsystem => 'Windows'} }
  	let(:params) { {:ensure => 'installed', :locale => 'fr', :cic_version => '2015_R2'} }
    it { 
    	should contain_class('ciclgpack')
    }
  end
end
