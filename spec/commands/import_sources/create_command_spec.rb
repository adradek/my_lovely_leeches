# frozen_string_literal: true

require "rails_helper"

RSpec.describe ImportSources::CreateCommand do
  subject(:command_call) { described_class.call(name:, format:, raw_memo:) }

  # let(:result) { command_call }
  # let(:file) { nil }
  # let(:data) { nil }

  describe ".call" do
    it "requires :format param"

    context "when format is 'raw'" do
      let(:format) { "raw" }
      let(:name) { "Some data copied from excel" }

      it "requires name"
      it "requires raw memo"

      context "with correct set of params" do
        let(:value) { command_call.value! }
        let(:raw_memo) { "[[\"1 \n\r\",\"2 \n\r\",\"3 \n\r\"],[\"4 \n\r\",\"5 \n\r\",\"6 \n\r\"]]" }
        let(:expected_memo) { [["1", "2", "3"], ["4", "5", "6"]] }

        it "succeeds" do
          expect(command_call).to be_success
        end

        it "creates new ImportSource" do
          expect { command_call }.to change(ImportSource, :count).by(1)
        end

        it "returns result with persisted instance of ImportSource", :aggregate_failures do
          expect(value).to be_an(ImportSource)
          expect(value).to be_persisted
        end

        it "stores memo" do
          expect(value.memo).not_to be_nil
        end

        it "sanitizes cell contents" do
          expect(value.memo).to eq(expected_memo)
        end
      end
    end

    # TODO: examine and remove
    # context "when neither file nor data is provided" do
    #   it "returns Failure" do
    #     expect(command_call).to be_failure
    #   end

    #   it "tags the failure with :source_missing" do
    #     expect(result.failure).to include(error: :source_missing, message: "File or data is required")
    #   end

    #   it "does not create any ImportSource" do
    #     expect { command_call }.not_to change(ImportSource, :count)
    #   end

    #   it "does not create any Import" do
    #     expect { command_call }.not_to change(Import, :count)
    #   end
    # end

    # context "with an .xls file" do
    #   let(:file) { fixture_file_better_upload("sample.xls") }
    #   let(:value) { command_call.value! }

    #   it "returns Success" do
    #     expect(result).to be_success
    #   end

    #   it "creates a single ImportSource" do
    #     expect { command_call }.to change(ImportSource, :count).by(1)
    #   end

    #   it "creates and returns Import", :aggregate_failures do
    #     expect { command_call }.to change(Import, :count).by(1)
    #     expect(value).to be_a(Import)
    #   end

    #   it "returns wrapped Import instance" do
    #     expect(value).to be_an(Import)
    #   end

    #   it "binds Import to ImportSource object" do
    #     expect(value.import_source).not_to be_nil
    #   end

    #   it "sets import_source's name" do
    #     expect(value.import_source.name).to eq(name)
    #   end

    #   it "attaches file to import_source", :aggregate_failures do
    #     expect(value.import_source.source).to be_attached
    #     expect(value.import_source.source.blob.filename).to eq(file.original_filename)
    #     expect(value.import_source.source.blob.content_type).to eq(file.content_type)
    #   end
    # end

    # context "with an .xlsx file", skip: "Returns Import, not ImportSource instance. Need to fix." do
    #   let(:file) { fixture_file_better_upload("sample.xlsx") }

    #   it "returns Success" do
    #     expect(result).to be_success
    #   end

    #   it "persists an ImportSource with xlsx format" do
    #     expect(result.value!.format).to eq("xlsx")
    #   end
    # end

    # context "with a file of unsupported content_type" do
    #   pending "returns Failure with :unsupported_format"
    #   pending "does not create any ImportSource"
    # end

    # context "with raw data and no file" do
    #   let(:data) { { foo: "bar" } }

    #   pending "delegates to ImportSourceBuilder::Raw"
    #   pending "persists an ImportSource with raw format"
    # end

    # context "when ImportSource persistence fails" do
    #   let(:file) { fixture_file_better_upload("sample.xls") }

    #   pending "rolls back the transaction and creates no Import"
    # end

    # context "with valid input parameters" do
    #   let(:file) { fixture_file_better_upload("sample.xls") }

    #   pending "creates an Import associated with the built ImportSource"
    #   pending "attaches the uploaded file to the ImportSource"
    # end
  end
end
