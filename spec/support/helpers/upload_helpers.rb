require "rack/mime"

module UploadHelpers
  def fixture_file_better_upload(path)
    mime = Rack::Mime.mime_type(File.extname(full_path(path)))
    fixture_file_upload(path, mime)
  end

  private

  def full_path(path)
    has_path?(path) ? path : Rails.root.join("spec", "fixtures", path).to_s
  end

  def has_path?(str)
    str.include?(File::SEPARATOR) || (File::ALT_SEPARATOR && str.include?(File::ALT_SEPARATOR))
  end
end
