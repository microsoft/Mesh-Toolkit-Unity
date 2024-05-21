// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

namespace WeatherAPI
{
    public class CurrentWeather
    {
        public Location? location { get; set; }
        public Current? current { get; set; }

        public string? GetFormattedWindDetails()
        {
            return $"The current weather information about {location?.name}, {location?.country} is gotten from WeatherAPI.com. Temperature is {current?.temp_f}�F / {current?.temp_c}�C. Wind speed is {current?.wind_mph}mph / {current?.wind_kph}kph, degree is {current?.wind_degree}, direction is {current?.wind_dir} and gust speed is {current?.gust_mph}mph / {current?.gust_kph}kph";
        }
    }
}