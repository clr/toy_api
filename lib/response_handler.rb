class ResponseHandler
  def initialize(object)
    @object = object
  end

  def to_s
    if @object
      ObjectViewer.new(@object).to_json
    else
      "Data not found. :-("
    end
  end
end
