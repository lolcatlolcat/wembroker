require 'spec_helper'

describe 'wembroker' do
  let(:title) { 'wembroker' } # this does exactly what you think - sets the title of the class declaration
  let(:node) { 'test.example.com' } # this sets a node name if needed
  #let(:facts) { {
  #  :fact1 => 'value 1',
  #  :fact2 => 'value 2',
  #} }   # this is where you can define facts for your tests like `osfamily`, `architecture`, `kernel`, etc.
  #let(:params) { {  # defined much like the facts, these are parameters that your class accepts
  #  'compress' => 'foo'
  #} }

  it { is_expected.to compile }   # this is the simplest test possible to make sure the Puppet code compiles
  it { is_expected.to compile.with_all_deps }  # same as above except it will test all the dependencies
end
