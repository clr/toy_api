# Create the keys for this API.
class KeyMaker
  def initialize(country, location, date, hour=nil)
    @country  = country
    @location = location
    @date     = date
    @hour   ||= hour
  end

  # Return the string.
  def format
    if @hour
      "#{@country}_#{@location}_#{@date}_#{@hour}"
    else
      "#{@country}_#{@location}_#{@date}"
    end
  end
end
