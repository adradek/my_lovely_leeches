module TaxonParser
  RANKS = {
    "тип" => :r_phylum,
    "класс" => :r_class,
    "п/класс" => :r_subclass,
    "отряд" => :r_order,
    "п/отряд" => :r_suborder,
    "сем." => :r_family,
    "п/сем." => :r_subfamily
  }.freeze

  MARKER_REGEX = /\A(?<marker>#{RANKS.keys.map { Regexp.escape(it) }.join("|")})\s+/u

  module_function

  def find_cyrillic(line)
    chars = line.scan(/[А-Яа-яЁё]/).uniq
    chars.empty? ? nil : chars
  end

  def normalize_line(line)
    line.to_s.strip
      .gsub(/\s+/, " ")
      .sub(/\s+\*+\s*$/, "")
      .sub(/^отр\.\s+/u, "отряд ")
      .sub(/^п\/кл\.\s+/u, "п/класс ")
  end

  def rank_by_marker(marker)
    RANKS[marker] || :r_species
  end

  def split_prefix(line)
    (m = line.match(MARKER_REGEX)) ? [m[:marker], m.post_match] : [nil, line]
  end
end
