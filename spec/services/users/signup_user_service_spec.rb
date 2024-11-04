require 'rails_helper'

RSpec.describe Users::SignupUserService do
  let(:user_params) { { email_address: 'test@example.com', password: 'password', password_confirmation: 'password', referer_code: } }
  let(:referer_code) { nil }
  let(:service) { described_class.new(user_params) }

  describe '#call' do
    context 'when user params are valid' do
      it 'creates a new user' do
        expect { service.call }.to change(User, :count).by(1)
      end

      it 'returns true' do
        expect(service.call).to be true
      end
    end

    context 'when user params are invalid' do
      before { user_params[:email_address] = '' }

      it 'does not create a new user' do
        expect { service.call }.not_to change(User, :count)
      end

      it 'returns false' do
        expect(service.call).to be false
      end
    end

    context 'when referer_code is present' do
      let!(:referrer) { create(:user) }
      let(:referer_code) { referrer.referral_code }

      it 'sets the referrer' do
        service.call
        expect(service.user.referred_by).to eq(referrer)
      end

      it 'handles referral status' do
        expect(Users::UpdateStatusService).to receive(:call).with(referrer)
        service.call
      end
    end

    context 'when referer_code is not present' do
      before { user_params[:referer_code] = nil }

      it 'does not set the referrer' do
        service.call
        expect(service.user.referred_by).to be_nil
      end

      it 'does not handle referral status' do
        expect(Users::UpdateStatusService).not_to receive(:call)
        service.call
      end
    end
  end
end
