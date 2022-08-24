class ExtensionScanner

  EXCLUDED_EXTENSIONS = [".txt", ""]

  def self.list_extensions(target_dir)
    files = Dir.children(target_dir + "/2022") # todo: fix this
    extension_records = []

    files.each do |f|
      ext = File.extname(f)

      if EXCLUDED_EXTENSIONS.include?(ext)
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
end
