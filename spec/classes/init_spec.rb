require 'puppetlabs_spec_helper/module_spec_helper'
require 'spec_helper'

describe 'ciclgpack' do

  context "Contains class" do
    let(:facts) { { :operatingsystem => 'Windows'} }
    let(:params) { {:ensure => 'installed', :locale => 'fr', :cic_version => '2015_R2'} }

    it { is_expected.to contain_class('ciclgpack') }
  end

  context "Only one class" do
    let(:facts) { { :operatingsystem => 'Windows'} }
    let(:params) { {:ensure => 'installed', :locale => 'fr', :cic_version => '2015_R2'} }

    it { should have_class_count(1) }
  end

  context "FR Locale - CIC 2015 R2" do
    let(:facts) { { :operatingsystem => 'Windows'} }
    let(:params) { {:ensure => 'installed', :locale => 'fr', :cic_version => '2015_R2'} }

    it { is_expected.to create_class('ciclgpack') }
  end

  context "NOT Windows" do
    let(:facts) { { :operatingsystem => 'Not Windows'} }
    let(:params) { {:ensure => 'installed', :locale => 'fr', :cic_version => '2015_R2'} }

    it do
      expect { is_expected.to create_class('ciclgpack') }.to raise_error(Puppet::Error, /Unsupported OS/)
    end
  end

end