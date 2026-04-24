module ImportSourceBuilder
  class Excel < ApplicationBuilder
    SUPPORTED_FORMATS = %i[xls xlsx].freeze

    def initialize(file:, name:)
      @file = file
      @name = name
    end

    def build
      format = yield resolve_format
      import_source = ImportSource.new(format:, name:, source: file)
      return Success(import_source) if import_source.save

      Failure(error: :import_source_creation_failed, message: import_source.errors.full_messages.to_sentence)
    end

    private

    attr_reader :file, :name

    def resolve_format
      if (fmt = file_extension.to_sym).in?(SUPPORTED_FORMATS)
        Success(fmt)
      else
        Failure(error: :unsupported_format, message: "Unsupported format: #{fmt}")
      end
    end

    def file_extension
      file.original_filename.split(".").last&.downcase
    end
  end
end
