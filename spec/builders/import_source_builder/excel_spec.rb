require "rails_helper"

RSpec.describe ImportSourceBuilder::Excel do
  subject(:builder_call) { builder.build }

  let(:builder) { described_class.new(file:, name:) }
  let(:file) { nil }

  describe "#build" do
    pending "returns an ImportSource"
    pending "sets format to :excel"
    pending "extracts metadata into memo"

    context "with xls file" do
      # .xls → application/vnd.ms-excel
      # .xlsx → application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
      # .xlsm (с макросами) → application/vnd.ms-excel.sheet.macroEnabled.12
      # .xlsb (binary) → application/vnd.ms-excel.sheet.binary.macroEnabled.12
      let(:file) { fixture_file_better_upload("sample.xls") }
      let(:name) { "Simple Excel File" }
      let(:persisted_instance) { builder_call }

      it "creates an ImportSource with format :xsl" do
        expect { builder_call }.to change(ImportSource, :count).by(1)
      end

      it "assigns specified name to the persisted instance" do
        expect(persisted_instance.name).to eq(name)
      end

      it "assigns format :xls to the persisted instance" do
        expect(persisted_instance.format).to eq("xls")
      end
    end
  end
end
