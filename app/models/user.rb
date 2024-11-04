class User < ApplicationRecord
  enum :status, { bronze: 0, silver: 1, gold: 2, platinum: 3 }
  has_secure_password

  belongs_to :referred_by, class_name: "User", optional: true
  has_many :referrals, class_name: "User", foreign_key: "referred_by_id"
  has_many :sessions, dependent: :destroy
  # enum status: { pending: 0, approved: 1, unapproved: 2 }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  attr_accessor :referer_code

  validate :validate_referer_code, if: -> { referer_code.presence && !persisted? }

  before_create :generate_referral_code

  private

  def generate_referral_code
    begin
      code = SecureRandom.hex(6)[..6]
    end while User.exists?(referral_code: code)

    self.referral_code = code
  end

  def validate_referer_code
    referrer = User.find_by(referral_code: referer_code)
    errors.add(:referer_code, "is invalid") unless referrer
  end
end
