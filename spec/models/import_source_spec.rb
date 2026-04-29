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
require "rails_helper"

RSpec.describe ImportSource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
