class Artist < ApplicationRecord
  has_many :songs
  validates :name, presence: true

  # mount_uploader :image, ImageUploader
end
