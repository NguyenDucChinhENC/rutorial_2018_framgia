class User < ApplicationRecord
  before_save :downcase_email

  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  ATTRIBUTES_PARAMS = [:name, :email,
    :password, :password_confirmation].freeze

  validates :name, presence: true, length: {maximum: Settings.max_name}
  validates :email, presence: true, length: {maximum: Settings.max_mail},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.min_pass},
    allow_nil: true

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end

      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_token: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_token.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_token: nil
  end

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end

      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_token: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_token.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_token: nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
