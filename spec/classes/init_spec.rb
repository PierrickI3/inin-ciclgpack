require 'puppetlabs_spec_helper/module_spec_helper'
require 'spec_helper'

describe 'ciclgpack' do
  let(:title) {'ciclgpack'}

  let(:params) { {:locale => 'fr', :cic_version => '2015_R2'} }
  let(:facts) { { :operatingsystem => 'Windows'} }

<<<<<<< HEAD
  context 'with defaults for all parameters' do
  	let(:facts) { {:operatingsystem => 'Windows'} }
  	let(:params) { {:ensure => 'installed', :locale => 'fr', :cic_version => '2015_R2'} }
    it { 
    	should contain_class('ciclgpack')
    }
  end
end
=======
  it { is_expected.to create_class('ciclgpack') }
end
>>>>>>> 09308efde5a2ce704996aed3c8b89721ba8b058c
