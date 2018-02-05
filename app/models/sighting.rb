# == Schema Information
#
# Table name: sightings
#
#  id                   :integer          not null, primary key
#  flower_id            :integer
#  user_id              :integer
#  name                 :string
#  description          :text
#  latitude             :decimal(10, 6)
#  longitude            :decimal(10, 6)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#
# Indexes
#
#  index_sightings_on_flower_id  (flower_id)
#  index_sightings_on_latitude   (latitude)
#  index_sightings_on_longitude  (longitude)
#  index_sightings_on_user_id    (user_id)
#

class Sighting < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :flower, counter_cache: true

  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  attr_accessor :picture_base

  before_validation :parse_base64_image
  validates :user, presence: true
  validates :flower, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  has_attached_file :picture,
    styles: { medium: '300x300>', thumb: '100x100>' },
    default_url: '/images/:style/missing.png'
  validates_attachment_content_type :picture,
    content_type: /\Aimage\/.*\z/

  has_many :likes
  has_many :comments

  def user_likes(user)
    likes.where(user_id: user.id)
  end

  acts_as_mappable default_units: :kms,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  after_create do |sighting|
    user_ids = sighting.flower.favourites.pluck(:user_id)
    user_tokens = User.where('id IN (?)', user_ids).pluck(:fcm_token)
    NotificationSender.new(user_tokens, 'Your favourite flower just got a new sighting').call
  end

  private

  def parse_base64_image
    return unless picture_base.present?
    data = StringIO.new(Base64.decode64(picture_base[:data]))
    data.class.class_eval { attr_accessor :original_filename, :content_type }
    data.original_filename = picture_base[:filename]
    data.content_type = picture_base[:content_type]
    self.picture = data
    # content = picture_base[:content]
    # image = Paperclip.io_adapters.for(content)
    # image.original_filename = picture_base['filename']
    # self.picture = image
  end
end
