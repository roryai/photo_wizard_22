require_relative 'spec_helper'
require_relative '../wizard'

RSpec.describe do
  photo_1_path = "/Users/rory/code/transfer_wizard_22/spec/test_photos/small_cat.jpg"

  it 'adds file path of photo to list of files to be transferred' do
    expect(Wizard.new.scan.first).to include photo_1_path
  end

  it 'adds file size to record' do
    expect(Wizard.new.scan.first).to include 12429
  end
end
