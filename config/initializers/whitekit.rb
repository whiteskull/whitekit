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

  def self.directory_hash(path, name=nil)
    data = {data: (name || path)}
    data[:children] = children = []
    Dir.foreach(path) do |entry|
      next if (entry == '..' || entry == '.')
      full_path = File.join(path, entry)
      if File.directory?(full_path)
        children << directory_hash(full_path, entry)
      else
        children << entry
      end
    end
    data
  end
end