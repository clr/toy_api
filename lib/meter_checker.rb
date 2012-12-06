class MeterChecker
  def initialize(user)
    @user = user
  end

  def usage(amount)
     true if @user && amount
  end
end
