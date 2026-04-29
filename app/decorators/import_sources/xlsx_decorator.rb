module ImportSources
  class XlsxDecorator < Base
    private

    def file_to_matrix(file)
      Roo::Excelx.new(file.path, extension: ".xlsx").then do |excel|
        excel.sheets.map.with_index do |name, i|
          { name:, data: excel.sheet(i).to_a }
        end
      end
    end

    def valid_format?
      import_source.xlsx?
    end
  end
end
