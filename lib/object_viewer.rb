# Format the Riak Object into what the web browser wants.
class ObjectViewer
  def initialize(object)
    @object = object
  end

  # Format it.
  def to_s
    @object.data
  end
end
