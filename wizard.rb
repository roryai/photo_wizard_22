require 'fileutils'
require 'pry'
require './file_record.rb'
require './logger.rb'

class Wizard

  SOURCE_DIR = "/Users/rory/code/transfer_wizard_22/spec/test_photos/source"
  TARGET_DIR = "/Users/rory/code/transfer_wizard_22/spec/test_photos/target"

  attr_reader :logger

  def initialize
    @logger = Logger.new(target_dir: TARGET_DIR,source_dir: SOURCE_DIR)
  end

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
      file_name = record.name

      if duplicate?(record)
        next
      end

      FileUtils.cp(record.source_path, TARGET_DIR)

      logger.log_success(file_name) if file_exists?(file_name)
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

  def duplicate?(record)
    if file_exists?(record.name)
      if File.size(TARGET_DIR + "/" + record.name) == record.size
        logger.log_already_exists(record.name)

        return true
      else
        base_name = File.basename(record.source_path, File.extname(record.source_path))
        new_name = TARGET_DIR + "/" + base_name + "_001" + File.extname(record.source_path)
        FileUtils.cp(record.source_path, new_name)
      end
    end
    false
  end

  def file_exists?(file_name)
    File.exist?(TARGET_DIR + "/" + file_name)
  end
end
