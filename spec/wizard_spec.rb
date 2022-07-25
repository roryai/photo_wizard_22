require_relative "spec_helper"
require_relative "../wizard.rb"
require_relative "../file_record.rb"

RSpec.describe do
  photo_1_path = "/Users/rory/code/transfer_wizard_22/spec/test_photos/source/small_cat.jpg"
  target_directory = "/Users/rory/code/transfer_wizard_22/spec/test_photos/target"

  describe "records" do
    it "adds file name to record" do
      expect(Wizard.new.scan.first.name).to eq "small_cat.jpg"
    end

    it "adds file path of photo to record" do
      expect(Wizard.new.scan.first.path).to eq photo_1_path
    end

    it "adds file size to record" do
      expect(Wizard.new.scan.first.size).to eq 12429
    end
  end

  describe "transfers" do
    it "ignores files that are not .jpg" do
      records = Wizard.new.scan
      expect(records.first.name).to eq "small_cat.jpg"
      expect(records.size).to eq 1
    end

    it "copies a jpg to the source directory" do
      Wizard.new.transfer
      Dir.chdir(target_directory)
      expect(File.exist?(photo_1_path)).to be true
    end

    it "does not copy a file with no extension" do
      Wizard.new.transfer
      Dir.chdir(target_directory)
      expect(File.exist?("no_ext_file")).to be false
    end

    it "does not copy a directory" do
      Wizard.new.transfer
      Dir.chdir(target_directory)
      expect(Dir.exist?("empty_dir")).to be false
    end
  end
end
