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
  # it_requires :name, :format
  it { is_expected.to validate_presence_of(:name) }

  context "with :raw format" do
    subject { build(:import_source, format: "raw") }

    it { is_expected.to validate_presence_of(:memo) }
  end

  context "with :csv format" do
    subject { build(:import_source, format: "csv") }

    it { is_expected.not_to validate_presence_of(:memo) }
  end
end
