ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$:.unshift(File.join(ROOT_DIR, 'app'))
$:.unshift(File.join(ROOT_DIR, 'lib'))

require 'sinatra'
require 'riak'
Dir[File.join(ROOT_DIR,'lib','*.rb')].each{|f| require f}

client = Riak::Client.new
version = 'v0.1'

# Match routes for the observation data.
get "/#{version}/observation/:country/:location/:date/:hour" do
  RequestMapper.new(client, params).observation
end
get "/#{version}/observation/:country/:location/:date" do
  RequestMapper.new(client, params).observation
end

# Match routes for the forecast data.
get "/#{version}/forecast/:country/:location/:date/:hour" do
  RequestMapper.new(client, params).forecast
end
get "/#{version}/forecast/:country/:location/:date" do
  RequestMapper.new(client, params).forecast
end

# Based on the route matched, execute an application.
class RequestMapper
  def initialize(client, params)
    @client = client
    @params = params
  end

  def observation
    @user = :anon
    begin
      UserChecker.new(@user).access(:read)
      MeterChecker.new(@user).usage(:unlimited)
    rescue => e
      halt "Permission denied for some reason. [#{e}]"
    end
    response = RequestProcessor.new(@client, 'observation', @params).process
    response.to_s
  end

  def forecast
    @user = :anon
    begin
      UserChecker.new(@user).access(:read)
      MeterChecker.new(@user).usage(:unlimited)
    rescue => e
      halt "Permission denied for some reason. [#{e}]"
    end
    response = RequestProcessor.new(@client, 'forecast', @params).process
    response.to_s
  end
end
