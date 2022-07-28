class Logger

  LOG_FILE_NAME = "/file_wizard_log.txt"

  attr_accessor :target_dir, :source_dir

  def initialize(target_dir:, source_dir:)
    @target_dir = target_dir
    @source_dir = source_dir
  end

  def log_already_exists(file_name)
    append("File " + file_name + " already exists in " + target_dir + "\n")
  end

  def log_success(file_name)
    append("Copied " + source_dir + "/" + file_name + " to " + target_dir + "/" + file_name + "\n")
  end

  def log_failure(file_name)
    append("Failed to copy " + source_dir + "/" + file_name + " to " + target_dir + "/" + file_name + "\n")
  end

  private

  def append(message)
    File.open(target_dir + LOG_FILE_NAME, "a+") do |file|
      file.write(message)
    end
  end
end
