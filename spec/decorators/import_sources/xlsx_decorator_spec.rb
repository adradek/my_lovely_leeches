# frozen_string_literal: true

require "rails_helper"

RSpec.describe ImportSources::XlsxDecorator do
  subject(:decorator) { described_class.new(import_source) }

  let(:import_source) do
    create(:import_source, format: :xlsx).tap do |source|
      source.source.attach(fixture_file_better_upload("sample.xlsx"))
    end
  end

  describe ".new" do
    context "when import_source is xlsx with an attached file" do
      it "initializes without raising" do
        expect { decorator }.not_to raise_error
      end
    end

    context "when import_source is not xlsx format" do
      let(:import_source) { build_stubbed(:import_source, format: :xls) }

      it "raises an invalid format error" do
        expect { decorator }.to raise_error(/Invalid import source format: xls/)
      end
    end

    context "when import_source has no attached file" do
      let(:import_source) { create(:import_source, format: :xlsx) }

      it "raises a missing file error" do
        expect { decorator }.to raise_error(/has not attached file/)
      end
    end
  end

  describe "#sheets" do
    subject(:sheets) { decorator.sheets }

    let(:expected_names) { ["Miki", "Doni", "Raf", "Leo"] }

    it "extracts every worksheet from the workbook" do
      expect(sheets.size).to eq(expected_names.size)
    end

    it "preserves sheet names in workbook order" do
      expect(sheets.pluck(:name)).to eq(expected_names)
    end

    it "shapes each sheet as a name/data hash" do
      expect(sheets).to all(match(name: kind_of(String), data: kind_of(Array)))
    end

    it "represents sheet contents as a row-major matrix" do
      expect(sheets.first[:data]).to all(be_an(Array))
    end
  end
end
