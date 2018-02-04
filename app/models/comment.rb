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

class Comment < ApplicationRecord
  belongs_to :sighting
  belongs_to :user

  validates :sighting, presence: true
  validates :user, presence: true
  validates :comment, presence: true

  after_create do |comment|
    sighting_user = comment.sighting.user
    NotificationSender.new(sighting_user.fcm_token, "#{comment.user.full_name} just commented on your sighting").call
  end
end
