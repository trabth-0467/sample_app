class User < ApplicationRecord
  USER_ATTRIBUTES = %i(name email password password_confirmation).freeze
  before_save :downcase_email

  validates :name, presence: true,
                   length: {maximum: Settings.user.name.max_length}

  validates :email, presence: true,
                    length: {maximum: Settings.user.email.max_length},
                    format: {with: Regexp.new(Settings.user.email.email_regex)},
                    uniqueness: {case_sensitive: false}

  validates :password, presence: true,
                       length: {minimum: Settings.user.password.min_length}

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
