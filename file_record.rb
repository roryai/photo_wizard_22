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
end
