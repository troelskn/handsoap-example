# -*- coding: utf-8 -*-
require 'handsoap'

class WeatherService < Handsoap::Service
  endpoint WEATHER_SERVICE_ENDPOINT
  on_create_document do |doc|
    doc.alias 'weat', "http://ws.cdyne.com/WeatherWS/"
  end
  # public methods
  def get_city_forecast_by_zip(zip_code)
    response = invoke("weat:GetCityForecastByZIP") do |message|
      message.add 'weat:ZIP', zip_code
    end
    node = response.document.xpath('//ns:GetCityForecastByZIPResult', ns).first
    parse_city_forecast_by_zip_result(node)
  end

  def get_city_weather_by_zip(zip_code)
    response = invoke("weat:GetCityWeatherByZIP") do |message|
      message.add 'weat:ZIP', zip_code
    end
    node = response.document.xpath('//ns:GetCityWeatherByZIPResult', ns).first
    parse_city_weather_by_zip_result(node)
  end

  def get_weather_information
    response = invoke("weat:GetWeatherInformation")
    response.document.xpath('//ns:WeatherDescription', ns).map { |node| parse_weather_description(node) }
  end

  def get_weather_information_by_id(weather_id)
    get_weather_information.find { |weather_description| weather_description[:weather_id].to_s == weather_id.to_s }
  end

  private
  def ns
    { 'ns' => 'http://ws.cdyne.com/WeatherWS/' }
  end

  # helpers
  def parse_weather_description(node)
    {
      :weather_id => node.xpath('./ns:WeatherID/text()', ns).to_s,
      :description => node.xpath('./ns:Description/text()', ns).to_s,
      :picture_url => node.xpath('./ns:PictureURL/text()', ns).to_s
    }
  end

  def parse_city_forecast_by_zip_result(node)
    {
      :success => node.xpath('./ns:Success/text()', ns).to_s == "true",
      :response_text => node.xpath('./ns:ResponseText/text()', ns).to_s,
      :state => node.xpath('./ns:State/text()', ns).to_s,
      :city => node.xpath('./ns:City/text()', ns).to_s,
      :weather_station_city => node.xpath('./ns:WeatherStationCity/text()', ns).to_s,
      :forecasts => node.xpath('./ns:ForecastResult/ns:Forecast', ns).map { |child| parse_forecast(child) }
    }
  end

  def parse_forecast(node)
    {
      :date => DateTime.strptime(node.xpath('./ns:Date/text()', ns).to_s, '%FT%T'),
      :weather_id => node.xpath('./ns:WeatherID/text()', ns).to_s,
      :description => node.xpath('./ns:Description/text()', ns).to_s,
      :temperatures => {
        :morning_low => node.xpath('./ns:Temperatures/ns:MorningLow/text()', ns).to_s.to_i,
        :daytime_high => node.xpath('./ns:Temperatures/ns:DaytimeHigh/text()', ns).to_s.to_i
      },
      :probability_of_precipiation => {
        :nighttime => node.xpath('./ns:ProbabilityOfPrecipiation/ns:Nighttime/text()', ns).to_s.to_i,
        :daytime => node.xpath('./ns:ProbabilityOfPrecipiation/ns:Daytime/text()', ns).to_s.to_i
      }
    }
  end

  def parse_city_weather_by_zip_result(node)
    {
      :success => node.xpath('./ns:Success/text()', ns).to_s == "true",
      :response_text => node.xpath('./ns:ResponseText/text()', ns).to_s,
      :state => node.xpath('./ns:State/text()', ns).to_s,
      :city => node.xpath('./ns:City/text()', ns).to_s,
      :weather_station_city => node.xpath('./ns:WeatherStationCity/text()', ns).to_s,
      :weather_id => node.xpath('./ns:WeatherID/text()', ns).to_s,
      :description => node.xpath('./ns:Description/text()', ns).to_s,
      :temperature => node.xpath('./ns:Temperature/text()', ns).to_s,
      :relative_humidity => node.xpath('./ns:RelativeHumidity/text()', ns).to_s,
      :wind => node.xpath('./ns:Wind/text()', ns).to_s,
      :pressure => node.xpath('./ns:Pressure/text()', ns).to_s,
      :visibility => node.xpath('./ns:Visibility/text()', ns).to_s,
      :wind_chill => node.xpath('./ns:WindChill/text()', ns).to_s,
      :remarks => node.xpath('./ns:Remarks/text()', ns).to_s,
    }
  end

end
