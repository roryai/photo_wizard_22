class FileRecord

  attr_accessor :name, :source_path, :size

  def initialize(name, source_path, size)
    @name = name
    @source_path = source_path
    @size = size
  end
end
