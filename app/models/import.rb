# == Schema Information
#
# Table name: imports
#
#  id               :bigint           not null, primary key
#  collected_on     :date
#  place            :string
#  point            :string
#  section          :string
#  state            :integer          default("initial"), not null
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
  include AASM

  belongs_to :import_source

  enum :state, { initial: 0, sourced: 1, determined: 2, parsed: 3, completed: 4, failed: 5 },
    instance_methods: false, scopes: false

  aasm column: :state, enum: true do
    state :initial, initial: true
    state :sourced, :determined, :parsed, :completed, :failed

    event :source do
      transitions from: :initial, to: :sourced
    end

    event :determine do
      transitions from: :sourced, to: :determined
    end

    event :parse do
      transitions from: :determined, to: :parsed
    end

    event :complete do
      transitions from: :parsed, to: :completed
    end

    event :fail do
      transitions from: %i[sourced parsed], to: :failed
    end
  end
end
