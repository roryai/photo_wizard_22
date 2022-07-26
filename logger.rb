class Logger

  LOG_DIR = "/file_wizard_log.txt"

  attr_accessor :target_dir, :source_dir, :file_name

  def initialize(target_dir:, source_dir: "", file_name:)
    @target_dir = target_dir
    @source_dir = source_dir
    @file_name = file_name
  end

  def log_already_exists
    append("File " + file_name + " already exists in " + target_dir + "\n")
  end

  def log_success
    append("Copied " + source_dir + "/" + file_name + " to " + target_dir + "/" + file_name + "\n")
  end

  private

  def append(message)
    File.open(target_dir + LOG_DIR, "a+") do |file|
      file.write(message)
    end
  end
end
