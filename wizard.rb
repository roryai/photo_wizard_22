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
        FileUtils.cp(record.source_path, new_path)
      else
        FileUtils.cp(record.source_path, record.target_path)
      end

      log_result(record)
    end
  end

  def list_extensions
    files = Dir.children(TARGET_DIR)
    extension_list = [[".heic", 0]]

    files.each do |f|
      ext = File.extname(f)
      extension_exists = extension_list.map do |record|
        record[0] == ext
      end[0]

      extension_list << [ext, 0] unless extension_exists || ext == ".txt"

      extension_list.each do |record|
        record[1] += 1 if record[0] == ext
      end
    end

    extension_list
  end


  private

  def scan
    Dir.chdir(SOURCE_DIR)
    records = []

    filter(Dir.children(SOURCE_DIR)).each do |f|
      records << FileRecord.new(
        name: File.basename(f),
        source_path: File.absolute_path(f),
        target_dir: TARGET_DIR,
        size: File.size(f)
      )
    end

    records
  end

  def filter(file_names)
    filtered_file_names = []

    file_names.each do |file_name|
      filtered_file_names << file_name if File.extname(file_name) == ".jpg"
    end

    filtered_file_names
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
    while File.exist?(record.target_dir + "/" + new_name) do
        new_name = increment(new_name)
    end
    record.target_dir + "/" + new_name
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
end
