# -*- coding: utf-8 -*-
require 'test_helper'

# WeatherService.logger = $stdout

class WeatherServiceTest < Test::Unit::TestCase
  def test_get_city_forecast_by_zip
    result = WeatherService.get_city_forecast_by_zip('90210')
    assert_equal "Beverly Hills", result[:city]
    assert result[:forecasts].length > 0
  end
  def test_get_city_weather_by_zip
    result = WeatherService.get_city_weather_by_zip('90210')
    assert_equal "Beverly Hills", result[:city]
  end
  def test_get_weather_information_by_id
    result = WeatherService.get_weather_information_by_id(4)
    assert_equal "Sunny", result[:description]
  end
end
