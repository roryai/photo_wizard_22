class FileRecord

  attr_accessor :name, :source_path, :target_path, :target_dir, :size

  def initialize(name:, source_path:, target_path:, size:)
    @name = name
    @source_path = source_path
    @target_path = target_path
    @size = size
  end

  def target_dir
    File.split(target_path)[0]
  end

  def generate_unique_path
    new_name = name
    split = File.split(target_path)
    while File.exist?(split[0] + "/" + new_name) do
      new_name = increment(new_name)
    end
    
    self.target_path = split[0] + "/" + new_name
  end

  def increment(name)
    extension = File.extname(name)
    name_no_ext = File.basename(name, ".*")
    number = /\d*$/.match(name_no_ext).to_s
    name_no_num = name_no_ext.chomp(number).chomp("_")

    name_no_num + "_" + (number.to_i + 1).to_s + extension
  end
end
