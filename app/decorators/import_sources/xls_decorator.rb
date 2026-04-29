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

    def valid_format?
      import_source.xls?
    end
  end
end
