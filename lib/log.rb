class Log
  def initialize(message)
    @message = message
  end

  def write
    File.open(File.join(ROOT_DIR,'log','notice.log'),'w'){|f| f.write @message}
  end
end
