# Connect to an ACL system to check user permissions.
class UserChecker
  def initialize(user)
    @user = user
  end

  # Check the access.
  def access(level)
    # Let them pass.
    if @user && level
      true
    # Write out the attempt to a log file.
    else
      Log.new("#{@user} tried to access with level @{level}.").write
      raise "Thou shall not pass."
    end
  end
end
