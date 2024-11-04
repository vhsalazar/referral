module Users
  class UpdateStatusService
    def initialize(user)
      @user = user
    end

    def call
      @user.status = calculate_status
      @user.save
    end

    attr_reader :user

    def self.call(user)
      new(user).call
    end

    private

    def calculate_status
      referrals_count  = user.referrals.count

      case referrals_count
      when 0...5
        User.statuses[:bronze]
      when 5...10
        User.statuses[:silver]
      when 10...20
        User.statuses[:gold]
      else
        User.statuses[:platinum]
      end
    end
  end
end
