class User < ApplicationRecord
  USER_ATTRIBUTES = %i(name email password password_confirmation).freeze
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true,
                   length: {maximum: Settings.user.name.max_length}

  validates :email, presence: true,
                    length: {maximum: Settings.user.email.max_length},
                    format: {with: Regexp.new(Settings.user.email.email_regex)},
                    uniqueness: {case_sensitive: false}

  validates :password, presence: true, allow_nil: true,
                       length: {minimum: Settings.user.password.min_length}

  has_secure_password

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end
  end

  attr_accessor :remember_token, :activation_token

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now,
                   activation_digest: nil
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end

  private

  def downcase_email
    email.downcase!
  end
end
