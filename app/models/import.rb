# == Schema Information
#
# Table name: imports
#
#  id               :bigint           not null, primary key
#  collected_on     :date
#  place            :string
#  point            :string
#  section          :string
#  status           :integer          default("initial"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  import_source_id :bigint           not null
#
# Indexes
#
#  index_imports_on_import_source_id  (import_source_id)
#
# Foreign Keys
#
#  fk_rails_...  (import_source_id => import_sources.id)
#
class Import < ApplicationRecord
  belongs_to :import_source

  validates :status, presence: true

  enum :status, { initial: 0, sourced: 1, parsed: 2, completed: 3, failed: 4 }
end
