module Taxons
  class PrepareTaxonCommand < ApplicationCommand
    def initialize(line)
      @line = line
    end

    def call
      normalized_line = yield normalize_line

      marker, name = TaxonParser.split_prefix(normalized_line)
      rank = TaxonParser.rank_by_marker(marker)
      name = yield avoid_cyrillic(name)

      # get the not persisted model
      Success(build_taxon(name:, rank:))
    end

    private

    attr_reader :line

    def avoid_cyrillic(name)
      return Success(name) unless (cyrillic = TaxonParser.find_cyrillic(name))

      Failure(
        error: :cyrillic_detected,
        message: "В имени таксона (#{name}) присутствуют кириллические символы: #{cyrillic.join(", ")}"
      )
    end

    def build_taxon(name:, rank:)
      Taxon.new(
        name:,
        rank:,
        full_name: [I18n.t("taxon.ranks.#{rank}"), name].compact_blank.join(" ")
      )
    end

    def normalize_line
      Success(TaxonParser.normalize_line(line))
    rescue => e
      Failure(error: :initial_normalization_error, message: e.message, error_class: e.class)
    end
  end
end
