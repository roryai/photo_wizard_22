require_relative "spec_helper"
require_relative "../wizard.rb"
require_relative "../file_record.rb"

RSpec.describe do
  photo_1 = "small_cat.jpg"
  source_directory = "/Users/rory/code/transfer_wizard_22/spec/test_photos/source"
  target_directory = "/Users/rory/code/transfer_wizard_22/spec/test_photos/target"
  photo_1_source_path = source_directory + "/" + photo_1
  photo_1_target_path = target_directory + "/" + photo_1
  log_file = target_directory + "/" + "file_wizard_log.txt"

  after(:each) do
    Dir.chdir(target_directory)
    Dir.children(target_directory).each do |file|
      File.delete(file)
    end

    log_file = "/Users/rory/code/transfer_wizard_22/spec/test_photos/target/file_wizard_log.txt"
    File.open(log_file, "w") # wipe_log_file
  end

  describe "records" do
    it "adds file name to record" do
      expect(Wizard.new.scan.first.name).to eq photo_1
    end

    it "adds file path source of photo to record" do
      expect(Wizard.new.scan.first.source_path).to eq source_directory + "/" + photo_1
    end

    it "adds file size to record" do
      expect(Wizard.new.scan.first.size).to eq 12429
    end
  end

  describe "transfers" do
    it "copies a jpg to the source directory" do
      Wizard.new.transfer
      Dir.chdir(target_directory)

      expect(File.exist?(photo_1)).to be true
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

    it "creates new name for files where name in use but size different" do
      Dir.chdir(target_directory)
      File.new(photo_1, "w")
      Wizard.new.transfer
      Dir.chdir(target_directory)

      expect(File.exist?("small_cat_1.jpg")).to be true
      expect(File.size?("small_cat_1.jpg"))
        .to eq (File.size?(photo_1_source_path))
    end

    it "creates new name for files where generated file name already in use" do
      Dir.chdir(target_directory)
      File.new(photo_1, "w")
      File.new("small_cat_1.jpg", "w")
      File.new("small_cat_2.jpg", "w")
      File.new("small_cat_3.jpg", "w")
      File.new("small_cat_4.jpg", "w")
      Wizard.new.transfer
      Dir.chdir(target_directory)

      expect(File.exist?("small_cat_5.jpg")).to be true
      expect(File.size?("small_cat_5.jpg"))
        .to eq (File.size?(photo_1_source_path))
    end
  end

  describe "logging" do
    it "logs a duplicate for a file that already exists" do
      Wizard.new.transfer
      Wizard.new.transfer

      Dir.chdir(target_directory)
      log = File.open(log_file).read

      expect(log).to eq "Copied " + photo_1_source_path + " to " + photo_1_target_path + "\n" + "File " + photo_1 + " already exists in " + target_directory + "\n"
    end

    it "logs a success for a transferred file" do
      Wizard.new.transfer
      Dir.chdir(target_directory)
      log = File.open(log_file, &:readline)

      expect(log).to eq "Copied " + photo_1_source_path + " to " + photo_1_target_path + "\n"
    end

  end
end
