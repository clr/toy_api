class ObjectViewer
  def initialize(object)
    @object = object
  end

  def to_json
    @object.data.to_json
  end
end
