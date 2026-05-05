# == Schema Information
#
# Table name: import_sources
#
#  id         :bigint           not null, primary key
#  format     :integer          default("raw"), not null
#  memo       :jsonb
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ImportSource < ApplicationRecord
  has_many :imports, dependent: :restrict_with_exception
  has_one_attached :source

  validates :memo, presence: true, if: :raw?
  validates :name, presence: true

  enum :format, { raw: 0, csv: 1, xls: 2, xlsx: 3 }
end
