class Taxon < ApplicationRecord
  belongs_to :parent, class_name: "Taxon", optional: true

  has_many :children, class_name: "Taxon", foreign_key: :parent_id, inverse_of: :parent

  enum :rank, {
    species: 10,
    genus: 20,
    subfamily: 25,
    family: 30,
    order: 40,
    subclass: 45,
    tclass: 50,
    phylum: 60,
    kingdom: 70
  }
end
