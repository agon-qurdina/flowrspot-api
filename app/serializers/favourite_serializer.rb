# == Schema Information
#
# Table name: favourites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  flower_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_favourites_on_flower_id  (flower_id)
#  index_favourites_on_user_id    (user_id)
#

class FavouriteSerializer < ActiveModel::Serializer
  # attributes :id
  belongs_to :flower, serializer: FlowersSerializer
end
