module ImportSources
  class RawDecorator < Base
    private

    def get_sheets
      [{ data: import_source.memo }]
    end

    def valid_format?
      import_source.raw?
    end
  end
end
