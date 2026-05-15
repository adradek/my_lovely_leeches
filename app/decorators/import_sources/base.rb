module ImportSources
  class Base
    def initialize(import_source)
      @import_source = import_source
      validate_import_source
    end

    def sheets
      @sheets ||= get_sheets
    end

    private

    attr_reader :import_source

    def get_sheets
      raise NotImplementedError, "Subclass must implement #get_sheets method"
    end

    def file_to_matrix(file)
      raise NotImplementedError, "Subclass must implement #file_to_matrix method"
    end

    def valid_format?
      raise NotImplementedError, "Subclass must implement #valid_format? method"
    end

    def file_attached?
      raise "import_source##{import_source.id} has not attached file" unless import_source.source.attached?
    end

    def validate_import_source
      raise "Invalid import source format: #{import_source.format}" unless valid_format?
    end
  end
end
