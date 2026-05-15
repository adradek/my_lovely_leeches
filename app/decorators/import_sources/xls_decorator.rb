module ImportSources
  class XlsDecorator < Base
    private

    def file_to_matrix(file)
      Roo::Excel.new(file.path, extension: ".xls").then do |excel|
        excel.sheets.map.with_index do |name, i|
          { name:, data: excel.sheet(i).to_a }
        end
      end
    end

    def get_sheets
      import_source.source.open { file_to_matrix(it) }
    end

    def valid_format?
      import_source.xls?
    end

    def validate_import_source
      super
      file_attached?
    end
  end
end
