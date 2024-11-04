require 'rails_helper'

RSpec.describe Users::UpdateStatusService, type: :service do
  let(:user) { create(:user) }

  let(:referral_count) { 0 }

  describe '#call' do
    subject { described_class.call(user) }

    before do
      expect(user).to receive(:referrals).and_return(double(count: referral_count))
    end

    context 'when the user has 0 to 4 referrals' do
      let(:referral_count) { 3 }

      it 'updates the status to bronze' do
        subject
        expect(user.status).to eq('bronze')
      end
    end

    context 'when the user has 5 to 9 referrals' do
      let(:referral_count) { 7 }

      it 'updates the status to silver' do
        subject
        expect(user.status).to eq('silver')
      end
    end

    context 'when the user has 10 to 19 referrals' do
      let(:referral_count) { 15 }

      it 'updates the status to gold' do
        subject
        expect(user.status).to eq('gold')
      end
    end

    context 'when the user has 20 or more referrals' do
      let(:referral_count) { 100 }

      it 'updates the status to platinum' do
        subject
        expect(user.status).to eq('platinum')
      end
    end
  end
end
