class WeatherSearchController < ApplicationController
  def search
    @details = nil
    @cached = true
    @address = params[:query]
    if @address.present?
      #read cache data
      @details = Rails.cache.read(@address)
      if @details.nil?
        @cached = false
        coordinates = get_cordinates(@address)
        @details = weather_details(coordinates.first, coordinates.last) if coordinates.present?
        #write cache
        Rails.cache.write(@address, @details, expires_in: 30.minute)
      end
    end
  end

  private
  #get latitude and longitude using address
  def get_cordinates(address)
    ua = Geocoder.search(address)
    ua.try(:first).try(:coordinates)
  end

  #call weather api to get weather details using latitude longitude
  def weather_details(latitude, longitude)
    url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&hourly=temperature_2m&daily=temperature_2m_max&daily=temperature_2m_min&current=temperature_2m"
    response = HTTParty.get(url)
    JSON.parse(response.body)
  end
end
