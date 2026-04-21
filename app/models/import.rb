class Import < ApplicationRecord
  belongs_to :import_source

  validates :status, presence: true

  enum :status, { initial: 0, sourced: 1, parsed: 2, completed: 3, failed: 4 }
end
