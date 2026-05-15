class ImportSourcesController < ApplicationController
  def show
    @import_source = ImportSource.find(params[:id])
  end

  def new
    @import_source = ImportSource.new(format:)
  end

  def create
    result = ImportSources::CreateCommand.call(**import_source_params.to_h.symbolize_keys)

    if result.success?
      redirect_to import_source_path(result.value!)
    else
      @import_source = result.failure[:import_source] || ImportSource.new
      render :new, status: :unprocessable_content
    end
  end

  private

  def import_source_params
    params.require(:import_source).permit(:name, :format, :source, :raw_memo)
  end

  def format
    params[:format].presence || "raw"
  end
end
