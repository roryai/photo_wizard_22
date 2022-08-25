require_relative "spec_helper"
require 'find'
require_relative "../wizard.rb"
require_relative "../file_record.rb"

RSpec.describe do
  photo_1 = "small_cat.jpg"
  source_directory = "/Users/rory/code/transfer_wizard_22/spec/test_photos/source"
  target_root_directory = "/Users/rory/code/transfer_wizard_22/spec/test_photos/target/"
  target_directory = "/Users/rory/code/transfer_wizard_22/spec/test_photos/target/2022"
  photo_1_source_path = source_directory + "/" + photo_1
  photo_1_target_path = target_directory + "/" + photo_1
  log_file = target_directory + "/" + "file_wizard_log.txt"

  after(:each) do
    Dir.chdir(target_root_directory)
    Dir.children(target_root_directory).each do |file|
      FileUtils.rm_rf(file) if File.exists?(file)
    end
  end

  describe "file transfers" do
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
      Dir.mkdir(target_directory)
      Dir.chdir(target_directory)
      File.new(photo_1, "w")
      Wizard.new.transfer
      Dir.chdir(target_directory)

      expect(File.exist?("small_cat_1.jpg")).to be true
      expect(File.size?("small_cat_1.jpg"))
        .to eq (File.size?(photo_1_source_path))
    end

    it "creates new name for files where generated file name already in use" do
      Dir.mkdir(target_directory)
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

    it "preserves creation time of original file" do
      Wizard.new.transfer

      original_birth_time = File.birthtime(photo_1_source_path).strftime("%Y%m%d")
      new_birth_time = File.birthtime(photo_1_target_path).strftime("%Y%m%d")

      expect(original_birth_time).to eq new_birth_time
    end
  end

  describe "copying to new directories" do
    it "generates a year folder for files to be transferred to" do
      Wizard.new.transfer
      Dir.chdir("/Users/rory/code/transfer_wizard_22/spec/test_photos/target")

      expect(Dir.exist?("2022")).to be true
    end

    it "copies a file to a year directory" do
      Wizard.new.transfer
      Dir.chdir(target_directory)

      expect(File.exist?(photo_1)).to be true
    end
  end

  describe "logging" do
    it "logs a duplicate for a file that already exists" do
      Dir.mkdir(target_directory)
      FileUtils.cp(photo_1_source_path, photo_1_target_path)
      Wizard.new.transfer

      Dir.chdir(target_directory)
      log = File.open(log_file).read

      expect(log).to eq "File " + photo_1 + " already exists at " + target_directory + "/" + photo_1 + "\n"
    end

    it "logs a success for a transferred file" do
      Wizard.new.transfer
      Dir.chdir(target_directory)
      log = File.open(log_file, &:readline)

      expect(log).to eq "Copied " + photo_1_source_path + " to " + photo_1_target_path + "\n"
    end
  end

  describe "extensions" do
    it "generates a list and count of file extensions for files in source directory" do
      files = ["test.heic", "test_2.heic", "test.jpg",
        "test.mov", "test.custom", "test"]

      Dir.mkdir(target_directory)
      files.each do |file|
        File.new(target_directory + "/" + file, "w")
      end

      extensions = Wizard.new.list_extensions

      expect(extensions).to include([".jpg", 1], [".heic", 2], [".mov", 1], [".custom", 1])
      expect(extensions.length).to eq 4
    end
  end
end
