module ImportSourcesHelper
  def render_sheets(import_source)
    case import_source.format
    when "xls"
      render("import_sources/excel/sheets", sheets: ImportSources::XlsDecorator.new(import_source).sheets)
    when "xlsx"
      render("import_sources/excel/sheets", sheets: ImportSources::XlsxDecorator.new(import_source).sheets)
    else
      raise "Unsupported format: #{import_source.format}"
    end
  end
end
