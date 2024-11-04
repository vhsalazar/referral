module Users
  class SignupUserService
    def initialize(user_params)
      @user_params = user_params
    end

    def call
      @user = User.new(@user_params)
      set_referrer

      return false unless @user.save

      post_signup_actions
      true
    end

    attr_reader :user

    private

    def post_signup_actions
      handle_referral_status
    end

    def handle_referral_status
      return unless @user.referred_by
      Users::UpdateStatusService.call(@user.referred_by)
    end

    def set_referrer
      return unless @user.referer_code

      referrer = User.find_by(referral_code: @user.referer_code)
      @user.referred_by = referrer if referrer
    end
  end
end
