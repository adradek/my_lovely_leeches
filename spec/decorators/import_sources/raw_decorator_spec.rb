# frozen_string_literal: true

require "rails_helper"

RSpec.describe ImportSources::RawDecorator do
  subject(:decorator) { described_class.new(import_source) }

  let(:import_source) { create(:import_source, format: "raw", memo:) }
  let(:memo) do
    [
      ["1", "2", "3"],
      ["4", "5", "6"]
    ]
  end

  describe ".new" do
    context "when import_source is xlsx with an attached file" do
      it "initializes without raising" do
        expect { decorator }.not_to raise_error
      end
    end

    context "when import_source is not valid format" do
      let(:import_source) { build_stubbed(:import_source, format: :xls) }

      it "raises an invalid format error" do
        expect { decorator }.to raise_error(/Invalid import source format: xls/)
      end
    end
  end

  describe "#sheets" do
    subject(:sheets) { decorator.sheets }

    it "contains only one sheet" do
      expect(sheets.size).to eq(1)
    end

    it "shapes sheet as a hash with data field" do
      expect(sheets).to all(match(data: kind_of(Array)))
    end
  end
end
