module ImportSources
  class CreateCommand < ApplicationCommand
    def initialize(name:, format:, raw_memo: nil)
      @name = name
      @format = format
      @raw_memo = raw_memo
    end

    def call
      import_source = yield prepare_import_source
      persist_import_source(import_source)
      # attach_file(persisted)
    end

    private

    attr_reader :name, :format, :raw_memo

    def prepare_import_source
      memo = yield prepare_memo
      import_source = ImportSource.new(name:, format:, memo:)
      Success(import_source)
    end

    def prepare_memo
      return Success(nil) if format.to_s != "raw"
      return Failure(error_type: :memo_absent, message: "Memo is absent") unless raw_memo

      Oj.load(raw_memo).each do |row|
        row.each do |cell|
          next unless cell
          cell.strip!
          cell.gsub!(/\s+/, " ")
        end
      end
        .then { |memo| Success(memo) }
    end

    def persist_import_source(import_source)
      if import_source.save
        Success(import_source)
      else
        Failure(
          error_type: :invalid_import_source,
          message: import_source.errors.full_messages.to_sentence,
          import_source:
        )
      end
    end
  end
end
