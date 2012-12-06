# Take the Riak object from a response, and deal with it.
class ResponseHandler
  def initialize(object)
    @object = object
  end

  def to_s
    # If we have a good object, return it.
    if @object
      ObjectViewer.new(@object).to_s
    # Otherwise return a message.
    else
      "Data not found. :-("
    end
  end
end
