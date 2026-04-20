class ImportSource < ApplicationRecord
  has_many :imports, dependent: :restrict_with_exception
  has_one_attached :source

  validates :name, presence: true
  validates :type, presence: true

  enum :type, { json: 0, csv: 1, xsl: 2, xslx: 3 }
end
