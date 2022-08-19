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
    scan.each do |record|
      file_name = record.name

      if duplicate?(record)
        logger.log_already_exists(record)
        next
      elsif name_clash?(record)
        new_path = generate_unique_path(record)
        copy_file(record.source_path, new_path)
      else
        copy_file(record.source_path, record.target_path)
      end

      log_result(record)
    end
  end

  def list_extensions
    files = Dir.children(TARGET_DIR)
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

  def scan
    Dir.chdir(SOURCE_DIR)

    filter(Dir.children(SOURCE_DIR)).map do |f|
      FileRecord.new(
        name: File.basename(f),
        source_path: File.absolute_path(f),
        target_path: new_target_path(File.absolute_path(f), TARGET_DIR),
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

  def generate_unique_path(record)
    new_name = record.name
    split = File.split(record.target_path)
    while File.exist?(split[0] + "/" + new_name) do
      new_name = increment(new_name)
    end
    split[0] + "/" + new_name
  end

  def increment(name)
    extension = File.extname(name)
    name_no_ext = File.basename(name, ".*")
    number = /\d*$/.match(name_no_ext).to_s
    name_no_num = name_no_ext.chomp(number).chomp("_")

    name_no_num + "_" + (number.to_i + 1).to_s + extension
  end

  def log_result(record)
    if file_exists?(record)
      logger.log_success(record)
    else
      logger.log_failure(record)
    end
  end

  def copy_file(source_path, target_path)
    target_dir = File.split(target_path)[0]
    name = File.split(target_path)[1]

    Dir.mkdir(target_dir) if !Dir.exist?(target_dir)
    FileUtils.cp(source_path, target_path, preserve: true)
  end

  def new_target_path(source_path, target_path)
    year = File.birthtime(source_path).strftime("%Y")
    filename = File.split(source_path)[1]
    new_target_path = File.join(target_path, year, filename)

    new_target_path
  end
end
