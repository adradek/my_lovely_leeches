module Imports
  class CreateImportCommand < ApplicationCommand
    def initialize(name:, file: nil, data: nil)
      @file = file
      @name = name
      @data = data
    end

    def call
      Import.transaction do
        @result = inner_call
        raise ActiveRecord::Rollback unless result.success?
      end

      result
    end

    private

    attr_reader :file, :name, :result

    def inner_call
      import_source = yield build_import_source
      create_import(import_source)
    end

    def build_import_source
      builder = yield select_builder
      builder.build
    end

    def create_import(import_source)
      import = Import.new(import_source:)

      if import.save
        import.source!
        Success(import)
      else
        Failure(error: :import_creation_failed, message: import.errors.full_messages.to_sentence)
      end
    end

    def select_builder
      # return ImportSourceBuilder::Raw if file is nil and data is present

      return Failure(error: :source_missing, message: "File or data is required") unless file

      case file.content_type
      when "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        Success(ImportSourceBuilder::Excel.new(file:, name:))
      end
    end
  end
end
