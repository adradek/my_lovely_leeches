class Taxon < ApplicationRecord
  belongs_to :parent, class_name: "Taxon", optional: true

  has_many :children, class_name: "Taxon", foreign_key: :parent_id, inverse_of: :parent

  enum :rank, {
    r_species: 10,
    r_genus: 20,
    r_subfamily: 25,
    r_family: 30,
    r_suborder: 35,
    r_order: 40,
    r_subclass: 45,
    r_class: 50,
    r_phylum: 60,
    r_kingdom: 70
  }
end
