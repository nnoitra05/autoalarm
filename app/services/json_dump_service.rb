

class JsonDumpService

  def self.write(hash, file_name)

    File.open(file_name, "w") do |file|
      JSON.dump(hash, file)
    end

  end

  def self.read(file_name)

    File.open(file_name) do |file|
      return JSON.load(file)
    end

  end

end