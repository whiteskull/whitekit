module Whitekit
  # Load file
  def self.read_file(file_name)
    File.open(file_name, 'r') { |f| f.read }
  end

  # Check if class exists
  def self.class_exists?(name)
    true if Kernel.const_get(name)
  rescue NameError
    false
  end

  def self.directory(path)
    data = {
        dir: [],
        file: []
    }
    if File.directory? path
      Dir.entries(path).sort.each do |item|
        next if item == '.' || item == '..' || "#{path}/#{item}" == "#{Rails.root}/tmp" || item == 'whitekit' || item == 'rails_admin'
        if File.directory? "#{path}/#{item}"
          data[:dir] << item unless item[0] == '.'
        else
          data[:file] << item
        end
      end
    end
    data
  end

end