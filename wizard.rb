require 'fileutils'
require 'pry'
require './file_record.rb'

class Wizard

  SOURCE_DIR = "/Users/rory/code/transfer_wizard_22/spec/test_photos/source"
  TARGET_DIR = "/Users/rory/code/transfer_wizard_22/spec/test_photos/target"

  def scan
    Dir.chdir(SOURCE_DIR)
    records = []

    filter(Dir.children(SOURCE_DIR)).each do |f|
      records << FileRecord.new(
        File.basename(f),
        File.absolute_path(f),
        File.size(f)
      )
    end

    records
  end

  def transfer
    scan.each do |record|
      FileUtils.cp(record.path, TARGET_DIR)
    end
  end

  private

  def filter(file_names)
    filtered_file_names = []
    
    file_names.each do |file_name|
      filtered_file_names << file_name if File.extname(file_name) == ".jpg"
    end

    filtered_file_names
  end
end
