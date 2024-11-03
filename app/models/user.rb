class User < ApplicationRecord
  has_secure_password

  belongs_to :referred_by, class_name: "User", optional: true
  has_many :referrals, class_name: "User", foreign_key: "referred_by_id"
  has_many :sessions, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  attr_accessor :referer_code

  validate :valdiate_referer_code, if: -> { referer_code.present? && !persisted? }

  def validate_referer_code
    referrer = User.find_by(referral_code: referer_code)
    errors.add(:referer_code, "is invalid") unless referrer
  end
end
