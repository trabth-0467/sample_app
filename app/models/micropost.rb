class Micropost < ApplicationRecord
  MICROPOST_ATTRIBUTES = %i(content image).freeze
  belongs_to :user
  scope :newest, ->{order created_at: :desc}
  validates :content, presence: true,
            length: {maximum: Settings.defaults.digit_140}

  validates :image,
            content_type: {
              in: Settings.defaults.image_types,
              message: I18n.t("micropost.image_format")
            },
            size: {
              less_than: Settings.defaults.max_image_size.megabytes,
              message: I18n.t("micropost.image_size")
            }

  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: [
                         Settings.defaults.micropost_image_width,
                         Settings.defaults.micropost_image_height
                       ]
  end
end
