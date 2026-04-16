# frozen_string_literal: true

require "rails_helper"

RSpec.describe Taxons::PrepareTaxonCommand do
  subject(:result) { described_class.call(line) }

  around { |example| I18n.with_locale(:en, &example) }

  describe ".call" do
    context "with a clean species line" do
      let(:line) { "Helobdella stagnalis (Linnaeus, 1758)" }

      it "returns Success" do
        expect(result).to be_success
      end

      it "wraps a non-persisted Taxon" do
        aggregate_failures do
          expect(result.value!).to be_a(Taxon)
          expect(result.value!).not_to be_persisted
        end
      end

      it "assigns the default species rank" do
        expect(result.value!.rank).to eq("r_species")
      end

      it "keeps the line as the taxon name" do
        expect(result.value!.name).to eq("Helobdella stagnalis (Linnaeus, 1758)")
      end

      it "builds full_name by prepending the translated rank" do
        expect(result.value!.full_name).to eq("Helobdella stagnalis (Linnaeus, 1758)")
      end
    end

    context "with surrounding and inner whitespace" do
      let(:line) { "  Hydra    sp.  " }

      it "collapses whitespace in the name" do
        expect(result.value!.name).to eq("Hydra sp.")
      end
    end

    context "with a trailing asterisk marker" do
      let(:line) { "Tubifex ignotus *" }

      it "strips the trailing marker" do
        expect(result.value!.name).to eq("Tubifex ignotus")
      end
    end

    {
      "тип Annelida" => { rank: "r_phylum", name: "Annelida", full_name: "phyl. Annelida" },
      "класс Hydrozoa" => { rank: "r_class", name: "Hydrozoa", full_name: "cl. Hydrozoa" },
      "п/класс Oligochaeta" => { rank: "r_subclass", name: "Oligochaeta", full_name: "subcl. Oligochaeta" },
      "отряд Diptera" => { rank: "r_order", name: "Diptera", full_name: "ord. Diptera" },
      "п/отряд Hydrachnidia" => { rank: "r_suborder", name: "Hydrachnidia", full_name: "subord. Hydrachnidia" },
      "сем. Naididae" => { rank: "r_family", name: "Naididae", full_name: "fam. Naididae" },
      "п/сем. Hydroporinae" => { rank: "r_subfamily", name: "Hydroporinae", full_name: "subfam. Hydroporinae" }
    }.each do |input, expected|
      context "when the line is #{input.inspect}" do
        let(:line) { input }

        it "strips the marker from the name" do
          expect(result.value!.name).to eq(expected[:name])
        end

        it "assigns rank #{expected[:rank]}" do
          expect(result.value!.rank).to eq(expected[:rank])
        end

        it "builds the localized full_name" do
          expect(result.value!.full_name).to eq(expected[:full_name])
        end
      end
    end

    context "with an abbreviated rank prefix" do
      it "expands 'отр.' into the 'отряд' marker and uses r_order" do
        taxon = described_class.call("отр. Diptera").value!
        aggregate_failures do
          expect(taxon.name).to eq("Diptera")
          expect(taxon.rank).to eq("r_order")
        end
      end

      it "expands 'п/кл.' into the 'п/класс' marker and uses r_subclass" do
        taxon = described_class.call("п/кл. Oligochaeta").value!
        aggregate_failures do
          expect(taxon.name).to eq("Oligochaeta")
          expect(taxon.rank).to eq("r_subclass")
        end
      end
    end

    context "when the input is nil" do
      let(:line) { nil }

      it "returns Success (to_s coerces nil to an empty string)" do
        expect(result).to be_success
      end

      it "produces a taxon with an empty name" do
        expect(result.value!.name).to eq("")
      end
    end

    context "when the name contains cyrillic characters" do
      let(:line) { "Анодонта sp." }

      it "returns Failure" do
        expect(result).to be_failure
      end

      it "tags the failure with :cyrillic_detected and lists the offending characters" do
        expect(result.failure).to match(
          error: :cyrillic_detected,
          message: a_string_including("А", "н", "о", "д", "т", "а")
        )
      end
    end

    context "when cyrillic appears only inside the body after a valid marker" do
      let(:line) { "тип Кольчатые" }

      it "still fails with :cyrillic_detected (marker is consumed before the check)" do
        expect(result.failure).to include(error: :cyrillic_detected)
      end
    end

    context "when normalization raises" do
      let(:line) { "anything" }

      before do
        allow(TaxonParser).to receive(:normalize_line).and_raise(Encoding::CompatibilityError, "bad encoding")
      end

      it "returns Failure" do
        expect(result).to be_failure
      end

      it "tags the failure with :initial_normalization_error" do
        expect(result.failure).to include(
          error: :initial_normalization_error,
          message: "bad encoding",
          error_class: Encoding::CompatibilityError
        )
      end
    end
  end
end
