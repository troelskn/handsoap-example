class WeatherController < ApplicationController
  def index
    @weather = WeatherService.get_city_weather_by_zip(params[:zip_code]) if params[:zip_code]
    @weather_information = WeatherService.get_weather_information_by_id(@weather[:weather_id]) if @weather
  end
end
