module ImportSourcesHelper
  def render_sheets(import_source)
    case import_source.format
    when "raw"
      render("import_sources/sheets/raw", sheets: ImportSources::RawDecorator.new(import_source).sheets)
    when "xls"
      render("import_sources/sheets/excel", sheets: ImportSources::XlsDecorator.new(import_source).sheets)
    when "xlsx"
      render("import_sources/sheets/excel", sheets: ImportSources::XlsxDecorator.new(import_source).sheets)
    else
      raise "Unsupported format: #{import_source.format}"
    end
  end

  def format_fields_partial_for(format)
    case format
    when "xls", "xlsx"
      "import_sources/excel_fields"
    when "csv"
      "import_sources/csv_fields"
    else
      "import_sources/raw_fields"
    end
  end
end
