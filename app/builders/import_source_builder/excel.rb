module ImportSourceBuilder
  class Excel
    def initialize(file:, name:)
      @file = file
      @name = name
    end

    def build
      ImportSource.create!(format:, name:)
    end

    private

    attr_reader :file, :name

    def format
      file_extension.to_sym
    end

    def file_extension
      file.original_filename.split(".").last&.downcase
    end
  end
end
