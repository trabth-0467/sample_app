class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: Settings.default.validations.name.presence,
                  length: {maximum: Settings.default.validations.name.maximum}
  validates :email, presence: Settings.default.validations.email.presence,
                  length: {maximum: Settings.default.validations.email.maximum},
    format: {with: Regexp.new(Settings.default.email_regex)},
    uniqueness: {case_sensitive: false}

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
