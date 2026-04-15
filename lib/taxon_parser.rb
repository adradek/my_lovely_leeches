module TaxonParser
  MARKERS = {
    "тип" => :phylum,
    "класс" => :tclass,
    "п/класс" => :subclass,
    "отряд" => :order,
    "п/отряд" => :suborder,
    "сем." => :family,
    "п/сем." => :subfamily
  }.freeze

  module_function

  def strip_prefix(line)
    regexp = %r{(#{MARKERS.keys.join("|")})}u
    line.sub(regexp, "").strip
  end

  def typos(line)
    line.match(/[А-Яа-я]/)
  end

  def has_typos?(line)
    typos(line).present?
  end
end
