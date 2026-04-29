require "rails_helper"

RSpec.describe ImportSourceBuilder::Excel do
  subject(:builder_call) { builder.build }

  let(:builder) { described_class.new(file:, name:) }
  let(:file) { nil }

  describe "#build" do
    pending "sets format to :excel"
    pending "extracts metadata into memo"

    context "with valid input parameters" do
      context "when file has .xls extension" do
        let(:filename) { "sample.xls" }
        let(:file) { fixture_file_better_upload(filename) }
        let(:name) { "Simple Excel File" }
        let(:value) { builder_call.value! }

        it "returns Success" do
          expect(builder_call).to be_success
        end

        it "creates an ImportSource with format :xsl" do
          expect { builder_call }.to change(ImportSource, :count).by(1)
        end

        it "wraps the created ImportSource instance inside the returned value" do
          expect(value).to be_a(ImportSource)
        end

        it "assigns specified name to the persisted instance" do
          expect(value.name).to eq(name)
        end

        it "assigns format :xls to the persisted instance" do
          expect(value.format).to eq("xls")
        end

        # rubocop:disable RSpec/ExampleLength
        it "attaches the file to the persisted instance", :aggregate_failures do
          expect(value.source).to be_attached

          value.source.blob.tap do |blob|
            expect(blob.filename).to eq(file.original_filename)
            expect(blob.content_type).to eq(file.content_type)
            expect(blob.byte_size).to eq(file.size)
            expect(blob.checksum).to eq(
              Digest::MD5.base64digest(File.binread(fixture_file_path(filename)))
            )
          end
        end
        # rubocop:enable RSpec/ExampleLength
      end
    end
  end
end
