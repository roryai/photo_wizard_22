class FileRecord

  attr_reader :name, :source_path, :target_path, :target_dir, :size
  attr_writer :target_path

  def initialize(name:, source_path:, root_target_dir:, size:)
    @name = name
    @source_path = source_path
    @target_path = generate_target_path(source_path, root_target_dir)
    @size = size
  end

  def target_dir
    File.split(target_path)[0]
  end

  def generate_unique_path
    new_name = name
    while File.exist?(target_dir + "/" + new_name) do
      new_name = increment(new_name)
    end

    self.target_path = target_dir + "/" + new_name
  end

  private

  def increment(name)
    extension = File.extname(name)
    name_no_ext = File.basename(name, ".*")
    number = /\d*$/.match(name_no_ext).to_s
    name_no_num = name_no_ext.chomp(number).chomp("_")

    name_no_num + "_" + (number.to_i + 1).to_s + extension
  end

  def generate_target_path(source_path, target_path)
    year = File.birthtime(source_path).strftime("%Y")
    File.join(target_path, year, name)
  end
end
