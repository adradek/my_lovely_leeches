# frozen_string_literal: true

require "rails_helper"
require "taxon_parser"

RSpec.describe TaxonParser do
  describe ".find_cyrillic" do
    it "returns unique cyrillic characters preserving first-appearance order" do
      expect(described_class.find_cyrillic("тип Porifera")).to eq(%w[т и п])
    end

    it "deduplicates repeated characters" do
      expect(described_class.find_cyrillic("ааб")).to eq(%w[а б])
    end

    it "recognises uppercase letters and Ё/ё" do
      expect(described_class.find_cyrillic("Ёжик")).to eq(%w[Ё ж и к])
    end

    it "returns nil when the line has no cyrillic characters" do
      expect(described_class.find_cyrillic("Helobdella stagnalis (Linnaeus, 1758)")).to be_nil
    end

    it "returns nil for an empty string" do
      expect(described_class.find_cyrillic("")).to be_nil
    end
  end

  describe ".normalize_line" do
    it "strips surrounding whitespace" do
      expect(described_class.normalize_line("  Hydra sp.  ")).to eq("Hydra sp.")
    end

    it "collapses inner whitespace" do
      expect(described_class.normalize_line("Hydra    sp.")).to eq("Hydra sp.")
    end

    it "removes a trailing asterisk marker" do
      expect(described_class.normalize_line("Tubifex ignotus *")).to eq("Tubifex ignotus")
    end

    it "removes multiple trailing asterisks" do
      expect(described_class.normalize_line("Hydra sp. **")).to eq("Hydra sp.")
    end

    it "expands the 'отр.' abbreviation into 'отряд'" do
      expect(described_class.normalize_line("отр. Diptera")).to eq("отряд Diptera")
    end

    it "expands the 'п/кл.' abbreviation into 'п/класс'" do
      expect(described_class.normalize_line("п/кл. Oligochaeta")).to eq("п/класс Oligochaeta")
    end

    it "coerces nil into an empty string" do
      expect(described_class.normalize_line(nil)).to eq("")
    end

    it "applies every normalization rule together" do
      expect(described_class.normalize_line("  отр.    Diptera   * ")).to eq("отряд Diptera")
    end
  end

  describe ".rank_by_marker" do
    {
      "тип" => :r_phylum,
      "класс" => :r_class,
      "п/класс" => :r_subclass,
      "отряд" => :r_order,
      "п/отряд" => :r_suborder,
      "сем." => :r_family,
      "п/сем." => :r_subfamily
    }.each do |marker, rank|
      it "maps #{marker.inspect} to #{rank.inspect}" do
        expect(described_class.rank_by_marker(marker)).to eq(rank)
      end
    end

    it "falls back to :r_species for an unknown marker" do
      expect(described_class.rank_by_marker("царство")).to eq(:r_species)
    end

    it "falls back to :r_species for nil" do
      expect(described_class.rank_by_marker(nil)).to eq(:r_species)
    end
  end

  describe ".split_prefix" do
    it "returns [nil, line] when there is no marker" do
      expect(described_class.split_prefix("Helobdella stagnalis")).to eq([nil, "Helobdella stagnalis"])
    end

    it "splits a known marker off the line" do
      expect(described_class.split_prefix("тип Annelida")).to eq(["тип", "Annelida"])
    end

    it "handles markers that contain a period" do
      expect(described_class.split_prefix("сем. Naididae")).to eq(["сем.", "Naididae"])
    end

    it "handles multi-part markers with a slash" do
      expect(described_class.split_prefix("п/класс Oligochaeta")).to eq(["п/класс", "Oligochaeta"])
    end

    it "tolerates multiple spaces between the marker and the body" do
      expect(described_class.split_prefix("тип   Porifera")).to eq(["тип", "Porifera"])
    end

    it "does not match a marker that is not followed by whitespace" do
      expect(described_class.split_prefix("типAnnelida")).to eq([nil, "типAnnelida"])
    end
  end
end
