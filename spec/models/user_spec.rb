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
end
