require 'fileutils'
require 'pry'
require './file_record.rb'
require './logger.rb'

class Wizard

  SOURCE_DIR = "/Users/rory/code/transfer_wizard_22/spec/test_photos/source"
  TARGET_DIR = "/Users/rory/code/transfer_wizard_22/spec/test_photos/target"

  attr_reader :logger

  def initialize
    @logger = Logger.new()
  end

  def transfer
    files_to_transfer.each do |record|
      if duplicate?(record)
        logger.log_already_exists(record)
        next
      elsif name_clash?(record)
        record.generate_unique_path
        copy_file(record)
      else
        copy_file(record)
      end

      log_result(record)
    end
  end

  def list_extensions
    files = Dir.children(TARGET_DIR + "/2022") # todo: fix this
    excluded_extensions = [".txt", ""]
    extension_records = []

    files.each do |f|
      ext = File.extname(f)

      if excluded_extensions.include?(ext)
        next
      elsif !extension_records.flatten.include?(ext)
        extension_records << [ext, 1]
      else
        record = extension_records.find {|record| record[0] == ext}
        record[1] += 1
      end
    end

    extension_records
  end

  private

  def files_to_transfer
    Dir.chdir(SOURCE_DIR)
    all_files = Dir.children(SOURCE_DIR)

    filter(all_files).map do |f|
      FileRecord.new(
        name: File.basename(f),
        source_path: File.absolute_path(f),
        root_target_dir: TARGET_DIR,
        size: File.size(f)
      )
    end
  end

  def filter(file_names)
    file_names.map do |file_name|
      file_name if File.extname(file_name) == ".jpg"
    end.compact
  end

  def duplicate?(record)
    file_exists?(record) && file_same_size?(record)
  end

  def name_clash?(record)
    file_exists?(record) && !file_same_size?(record)
  end

  def file_exists?(record)
    File.exist?(record.target_path)
  end

  def file_same_size?(record)
    File.size(record.target_path) == record.size
  end

  def log_result(record)
    if file_exists?(record)
      logger.log_success(record)
    else
      logger.log_failure(record)
    end
  end

  def copy_file(record)
    Dir.mkdir(record.target_dir) if !Dir.exist?(record.target_dir)
    FileUtils.cp(record.source_path, record.target_path, preserve: true)
  end
end
