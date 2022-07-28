require 'fileutils'
require 'pry'
require './file_record.rb'
require './logger.rb'

class Wizard

  SOURCE_DIR = "/Users/rory/code/transfer_wizard_22/spec/test_photos/source"
  TARGET_DIR = "/Users/rory/code/transfer_wizard_22/spec/test_photos/target"

  attr_reader :logger

  def initialize
    @logger = Logger.new(target_dir: TARGET_DIR, source_dir: SOURCE_DIR)
  end

  def scan
    Dir.chdir(SOURCE_DIR) #why is this here?
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
        logger.log_already_exists(record.name)
        next
      elsif name_clash?(record)
        new_path = generate_unique_path(record)
        FileUtils.cp(record.source_path, new_path)
      else
        FileUtils.cp(record.source_path, TARGET_DIR)
      end

      log_result(file_name)
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
    file_exists?(record.name) && file_same_size?(record)
  end

  def name_clash?(record)
    file_exists?(record.name) && !file_same_size?(record)
  end

  def file_exists?(file_name)
    File.exist?(TARGET_DIR + "/" + file_name)
  end

  def file_same_size?(record)
    File.size(TARGET_DIR + "/" + record.name) == record.size
  end

  def increment(name)
    extension = File.extname(name)
    base_name = File.basename(name, ".*")
    number = /\d*$/.match(base_name).to_s
    name_no_num = base_name.chomp(number).chomp("_")

    name_no_num + "_" + (number.to_i + 1).to_s + extension
  end

  def generate_unique_path(record)
    new_name = record.name
    while file_exists?(new_name) do
        new_name = increment(new_name)
    end
    TARGET_DIR + "/" + new_name
  end

  def log_result(file_name)
    if file_exists?(file_name)
      logger.log_success(file_name)
    else
      logger.log_failure(file_name)
    end
  end
end
