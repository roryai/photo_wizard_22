class FileRecord

  attr_accessor :name, :path, :size

  def initialize(name, path, size)
    @name = name
    @path = path
    @size = size
  end
end
