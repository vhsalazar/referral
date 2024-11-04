require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'associations' do
    it 'belongs to referred_by (User)' do
      expect(subject).to belong_to(:referred_by).class_name("User").optional
    end

    it 'has many referrals (User)' do
      expect(subject).to have_many(:referrals).class_name("User").with_foreign_key("referred_by_id")
    end

    it 'has many sessions' do
      expect(subject).to have_many(:sessions).dependent(:destroy)
    end
  end

  describe 'validations' do
    context 'email_address' do
      it { is_expected.to validate_presence_of(:email_address) }
      it { is_expected.to allow_value("somebody@domain.com").for(:email_address) }
      it { is_expected.not_to allow_value("somebody.domain.com").for(:email_address) }
      it { is_expected.to validate_uniqueness_of(:email_address).case_insensitive }
    end

    xcontext 'password' do
      it { is_expected.to validate_presence_of(:password_digest) }
    end
  end

  describe 'referral_code' do
    context 'when creating a new user' do
      it 'generates a referral_code' do
        user = create(:user)
        expect(user.referral_code).to be_present
        expect(user.referral_code.length).to eq(User::REFERRAL_CODE_LENGTH)
      end
    end

    context 'when the referralc_code already exists' do
      it 'does not allow duplicates' do
        user1 = create(:user)
        user2 = create(:user)
        user2.referral_code = user1.referral_code
        expect { user2.save! }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  context 'referer_code' do
    it 'is invalid if referer_code does not exist' do
      user = build(:user, referer_code: 'invalid_code')
      user.validate
      expect(user.errors[:referer_code]).to include("is invalid")
    end

    it 'is valid if referer_code exists' do
      referrer = create(:user)
      user = build(:user, referer_code: referrer.referral_code)
      user.validate
      expect(user.errors[:referer_code]).to be_empty
    end
  end
end
