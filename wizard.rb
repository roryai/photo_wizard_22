class Wizard

  SOURCE = "/Users/rory/code/transfer_wizard_22/spec/test_photos"

  def scan
    Dir.chdir(SOURCE)
    file_names = Dir.children(SOURCE)

    records = []

    file_names.each do |f|
      records << [File.absolute_path(f), File.size(f)]
    end

    records
  end

end
