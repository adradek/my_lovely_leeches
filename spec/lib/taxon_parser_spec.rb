# frozen_string_literal: true

require "rails_helper"
require "taxon_parser"

RSpec.describe TaxonParser do
  describe ".strip_prefix" do
    subject(:result) { described_class.strip_prefix(line) }

    context "with a rank prefix" do
      it "strips 'тип'" do
        expect(described_class.strip_prefix("тип Porifera")).to eq("Porifera")
      end

      it "strips 'класс'" do
        expect(described_class.strip_prefix("класс Insecta")).to eq("Insecta")
      end

      it "strips 'п/класс'" do
        expect(described_class.strip_prefix("п/класс Oligochaeta sp.")).to eq("Oligochaeta sp.")
      end

      it "strips 'отряд'" do
        expect(described_class.strip_prefix("отряд Diptera")).to eq("Diptera")
      end

      it "strips 'п/отряд'" do
        expect(described_class.strip_prefix("п/отряд Hydrachnidia n.det.")).to eq("Hydrachnidia n.det.")
      end

      it "strips 'сем.'" do
        expect(described_class.strip_prefix("сем. Chironomidae sp.")).to eq("Chironomidae sp.")
      end

      it "strips 'п/сем.'" do
        expect(described_class.strip_prefix("п/сем. Chironominae sp.")).to eq("Chironominae sp.")
      end
    end

    context "without a rank prefix" do
      it "returns the line unchanged" do
        expect(described_class.strip_prefix("Tubifex ignotus (Stolc, 1886)")).to eq("Tubifex ignotus (Stolc, 1886)")
      end

      it "strips surrounding whitespace" do
        expect(described_class.strip_prefix("  Hydra sp.  ")).to eq("Hydra sp.")
      end

      it "returns an empty string for a blank line" do
        expect(described_class.strip_prefix("   ")).to eq("")
      end
    end

    context "with a prefix and extra whitespace" do
      it "strips trailing whitespace from the result" do
        expect(described_class.strip_prefix("тип  Porifera")).to eq("Porifera")
      end
    end
  end

  describe ".typos" do
    it "returns a MatchData when the line contains Cyrillic characters" do
      expect(described_class.typos("тип Porifera")).to be_a(MatchData)
    end

    it "returns nil when the line contains no Cyrillic characters" do
      expect(described_class.typos("Tubifex ignotus (Stolc, 1886)")).to be_nil
    end

    it "returns nil for an empty string" do
      expect(described_class.typos("")).to be_nil
    end
  end

  describe ".has_typos?" do
    it "returns true when the line contains Cyrillic characters" do
      expect(described_class.has_typos?("отряд Diptera")).to be true
    end

    it "returns false for a pure Latin scientific name" do
      expect(described_class.has_typos?("Helobdella stagnalis (Linnaeus, 1758)")).to be false
    end

    it "returns false for an empty string" do
      expect(described_class.has_typos?("")).to be false
    end

    it "returns false after strip_prefix removes the only Cyrillic word" do
      stripped = described_class.strip_prefix("тип Porifera")
      expect(described_class.has_typos?(stripped)).to be false
    end
  end
end
