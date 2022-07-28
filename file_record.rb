class FileRecord

  attr_accessor :name, :source_path, :target_dir, :size

  def initialize(name:, source_path:, target_dir:, size:)
    @name = name
    @source_path = source_path
    @target_dir = target_dir
    @size = size
  end

  def target_path
    target_dir + "/" + name
  end
end
