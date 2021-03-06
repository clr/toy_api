# Load some files, bootstrap.
ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$:.unshift(File.join(ROOT_DIR, 'app'))
$:.unshift(File.join(ROOT_DIR, 'lib'))
require 'sinatra'
require 'riak'
Dir[File.join(ROOT_DIR,'lib','*.rb')].each{|f| require f}

# Connect to Riak.
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

  # Run the observation API.
  def observation
    # Set the user here when you have an ACL.
    @user = :anon
    # Check to see if the user has permission.
    begin
      # Check to see if the user has permission.
      UserChecker.new(@user).access(:read)
      # Check to see if the user has passed their metered quota.
      MeterChecker.new(@user).usage(:unlimited)
    rescue => e
      halt "Permission denied for some reason. [#{e}]"
    end
    # Process the request.
    response = RequestProcessor.new(@client, 'observation', @params).process
    # Return the result to the browser.
    response.to_s
  end

  # Run the forecast API.
  def forecast
    # Set the user here when you have an ACL.
    @user = :anon
    begin
      # Check to see if the user has permission.
      UserChecker.new(@user).access(:read)
      # Check to see if the user has passed their metered quota.
      MeterChecker.new(@user).usage(:unlimited)
    rescue => e
      halt "Permission denied for some reason. [#{e}]"
    end
    # Process the request.
    response = RequestProcessor.new(@client, 'forecast', @params).process
    # Return the result to the browser.
    response.to_s
  end
end
