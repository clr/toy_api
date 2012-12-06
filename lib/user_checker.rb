class UserChecker
  def initialize(user)
    @user = user
  end

  def access(level)
    if @user && level
      true
    else
      Log.new("#{@user} tried to access with level @{level}.").write
    end
  end
end
