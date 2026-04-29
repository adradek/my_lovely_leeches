require "rack/mime"

module UploadHelpers
  def fixture_file_better_upload(path)
    mime = Rack::Mime.mime_type(File.extname(fixture_file_path(path)))
    fixture_file_upload(path, mime)
  end

  def fixture_file_path(path)
    has_path?(path) ? path : Rails.root.join("spec", "fixtures", "files", path).to_s
  end

  private

  def has_path?(str)
    str.include?(File::SEPARATOR) || (File::ALT_SEPARATOR && str.include?(File::ALT_SEPARATOR))
  end
end
