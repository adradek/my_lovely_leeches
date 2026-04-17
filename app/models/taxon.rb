class Taxon < ApplicationRecord
  include Comparable

  belongs_to :parent, class_name: "Taxon", optional: true

  has_many :children, class_name: "Taxon", foreign_key: :parent_id, inverse_of: :parent

  validates :name, presence: true, uniqueness: { scope: [:rank, :parent_id] }
  validates :rank, presence: true

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

  def <=>(other)
    rank_num <=> other.rank_num
  end

  def rank_num
    Taxon.ranks[rank]
  end
end
