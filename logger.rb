class Logger

  LOG_FILE_NAME = "/file_wizard_log.txt"

  def log_already_exists(record)
    append("File " + record.name + " already exists at " + record.target_path + "\n", record)
  end

  def log_success(record)
    append("Copied " + record.source_path + " to " + record.target_path + "\n", record)
  end

  def log_failure(record)
    append("Failed to copy " + record.source_path + " to " + record.target_path + "\n", record)
  end

  private

  def append(message, record)
    File.open(record.target_dir + LOG_FILE_NAME, "a+") do |file|
      file.write(message)
    end
  end
end
