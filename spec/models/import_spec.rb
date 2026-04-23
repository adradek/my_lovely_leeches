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
require "rails_helper"

RSpec.describe Import, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
