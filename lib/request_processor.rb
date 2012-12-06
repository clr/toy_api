# Interpret the request and get the answer from Riak.
class RequestProcessor
  def initialize(client, dataset, params)
    @client  = client
    @dataset = dataset
    @params  = params
  end

  # Get the answer from Riak.
  def process
    key = KeyMaker.new(@params[:country], @params[:location], @params[:date], @params[:hour]).format
    bucket = @client.bucket(@dataset)
    object = bucket.get(key) rescue nil
    ResponseHandler.new(object).to_s
  end
end
