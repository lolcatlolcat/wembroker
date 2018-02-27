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

  let(:manifest) {
      <<-EOS
include wembroker
EOS
    }

  it 'should apply without errors' do
    apply_manifest(manifest, :catch_failures => true)
  end

  it 'should apply a second time without changes' do
    @result = apply_manifest(manifest)
    expect(@result.exit_code).to be_zero
  end
end
