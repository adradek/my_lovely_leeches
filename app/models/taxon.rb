# == Schema Information
#
# Table name: taxons
#
#  id         :bigint           not null, primary key
#  full_name  :string
#  name       :string           not null
#  name_ru    :string
#  rank       :integer          default("r_species"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :bigint
#
# Indexes
#
#  index_taxons_on_name_and_rank_and_parent_id  (name,rank,parent_id) UNIQUE NULLS NOT DISTINCT
#  index_taxons_on_parent_id                    (parent_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => taxons.id)
#
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

  # TODO: change the approach, cause it makes two taxons equal when their ranks are equal
  def <=>(other)
    rank_num <=> other.rank_num
  end

  def rank_num
    Taxon.ranks[rank]
  end
end
