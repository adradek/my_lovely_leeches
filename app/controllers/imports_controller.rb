class ImportsController < ApplicationController
  def new
    @import = Import.new
  end

  def create
    # import_source = ImportSource.create!(format: :xslx, name: "placeholder")
    # import_source.source.attach(params[:import][:file])

    # @import = Import.new(import_params)
    # @import.import_source = import_source

    result = Imports::CreateImportCommand.call(name: "placeholder", file: params[:import][:file])

    if result.success?
      @import = result.value!
      redirect_to @import, notice: "Import created successfully"
    else
      render :new
    end
  end

  def show
    @import = Import.find(params[:id])
  end

  private

  def import_params
    params.require(:import).permit(:import_source_id)
  end
end
