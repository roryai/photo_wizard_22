require_relative 'spec_helper'
require_relative '../wizard'

RSpec.describe do

  it 'adds file path of photo to list of files to be transferred' do
    wiz = Wizard.new

    expect(wiz.scan).to include "/Users/rory/code/transfer_wizard_22/spec/test_photos/small_cat.jpg"
  end

end
