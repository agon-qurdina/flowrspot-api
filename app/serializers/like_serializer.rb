class LikeSerializer < ActiveModel::Serializer
  # attributes :id
  belongs_to :user, serializer: UserSerializer
end
