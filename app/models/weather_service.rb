# -*- coding: utf-8 -*-
require 'handsoap'

class WeatherService < Handsoap::Service
  endpoint WEATHER_SERVICE_ENDPOINT
  on_create_document do |doc|
    doc.alias 'weat', "http://ws.cdyne.com/WeatherWS/"
  end
  # public methods
  def get_city_forecast_by_zip(zip_code)
    response = invoke("weat:GetCityForecastByZIP", :soap_action => :none) do |message|
      message.add 'weat:ZIP', zip_code
    end
    node = response.document.xpath('//ns:GetCityForecastByZIPResult', ns).first
    parse_city_forecast_by_zip_result(node)
  end

  def get_city_weather_by_zip(zip_code)
    response = invoke("weat:GetCityWeatherByZIP", :soap_action => :none) do |message|
      message.add 'weat:ZIP', zip_code
    end
    node = response.document.xpath('//ns:GetCityWeatherByZIPResult', ns).first
    parse_city_weather_by_zip_result(node)
  end

  def get_weather_information
    response = invoke("weat:GetWeatherInformation", :soap_action => :none)
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
      :weather_id => xml_to_str(node, './ns:WeatherID/text()'),
      :description => xml_to_str(node, './ns:Description/text()'),
      :picture_url => xml_to_str(node, './ns:PictureURL/text()')
    }
  end

  def parse_city_forecast_by_zip_result(node)
    {
      :success => xml_to_bool(node, './ns:Success/text()'),
      :response_text => xml_to_str(node, './ns:ResponseText/text()'),
      :state => xml_to_str(node, './ns:State/text()'),
      :city => xml_to_str(node, './ns:City/text()'),
      :weather_station_city => xml_to_str(node, './ns:WeatherStationCity/text()'),
      :forecasts => node.xpath('./ns:ForecastResult/ns:Forecast', ns).map { |child| parse_forecast(child) }
    }
  end

  def parse_forecast(node)
    {
      :date => xml_to_date(node, './ns:Date/text()'),
      :weather_id => xml_to_str(node, './ns:WeatherID/text()'),
      :description => xml_to_str(node, './ns:Description/text()'),
      :temperatures => {
        :morning_low => xml_to_int(node, './ns:Temperatures/ns:MorningLow/text()'),
        :daytime_high => xml_to_int(node, './ns:Temperatures/ns:DaytimeHigh/text()')
      },
      :probability_of_precipiation => {
        :nighttime => xml_to_int(node, './ns:ProbabilityOfPrecipiation/ns:Nighttime/text()'),
        :daytime => xml_to_int(node, './ns:ProbabilityOfPrecipiation/ns:Daytime/text()')
      }
    }
  end

  def parse_city_weather_by_zip_result(node)
    {
      :success => xml_to_bool(node, './ns:Success/text()'),
      :response_text => xml_to_str(node, './ns:ResponseText/text()'),
      :state => xml_to_str(node, './ns:State/text()'),
      :city => xml_to_str(node, './ns:City/text()'),
      :weather_station_city => xml_to_str(node, './ns:WeatherStationCity/text()'),
      :weather_id => xml_to_str(node, './ns:WeatherID/text()'),
      :description => xml_to_str(node, './ns:Description/text()'),
      :temperature => xml_to_str(node, './ns:Temperature/text()'),
      :relative_humidity => xml_to_str(node, './ns:RelativeHumidity/text()'),
      :wind => xml_to_str(node, './ns:Wind/text()'),
      :pressure => xml_to_str(node, './ns:Pressure/text()'),
      :visibility => xml_to_str(node, './ns:Visibility/text()'),
      :wind_chill => xml_to_str(node, './ns:WindChill/text()'),
      :remarks => xml_to_str(node, './ns:Remarks/text()'),
    }
  end

end
