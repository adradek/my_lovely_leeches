# == Schema Information
#
# Table name: import_sources
#
#  id         :bigint           not null, primary key
#  format     :integer          default("json"), not null
#  memo       :jsonb
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ImportSource < ApplicationRecord
  has_many :imports, dependent: :restrict_with_exception
  has_one_attached :source

  validates :name, presence: true
  validates :format, presence: true

  enum :format, { json: 0, csv: 1, xsl: 2, xslx: 3 }
end
