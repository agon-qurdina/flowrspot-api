# == Schema Information
#
# Table name: likes
#
#  id          :integer          not null, primary key
#  sighting_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_likes_on_sighting_id  (sighting_id)
#  index_likes_on_user_id      (user_id)
#

FactoryGirl.define do
  factory :like do
    sighting { create(:sighting) }
    user { create(:user) }
  end
end