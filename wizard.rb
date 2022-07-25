require 'fileutils'
require 'pry'
require './file_record.rb'

class Wizard

  SOURCE_DIR = "/Users/rory/code/transfer_wizard_22/spec/test_photos/source"
  TARGET_DIR = "/Users/rory/code/transfer_wizard_22/spec/test_photos/target"
  LOG_DIR = TARGET_DIR + "/" + "file_wizard_log.txt"

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
      if File.exist?(TARGET_DIR + "/" + record.name)
        log_already_exists(record.name)
        next
      end

      FileUtils.cp(record.path, TARGET_DIR)

      if File.exist?(TARGET_DIR + "/" + record.name)
        log_success(record.name)
      end
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

  def log_already_exists(file_name)
    File.open(LOG_DIR, "a+") do |file|
      file.write("File " + file_name + " already exists in " + TARGET_DIR + "\n")
    end
  end

  def log_success(file_name)
    File.open(LOG_DIR, "a+") do |file|
      file.write("Copied " + SOURCE_DIR + "/" + file_name + " to " + TARGET_DIR + "/" + file_name + "\n")
    end
  end
end
