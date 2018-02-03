# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  comment     :text
#  sighting_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_comments_on_sighting_id  (sighting_id)
#  index_comments_on_user_id      (user_id)
#

FactoryGirl.define do
  factory :comment do
    comment 'Such a nice photo!'
    sighting { create(:sighting) }
    user { create(:user) }
  end
end
