// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using Azure;
using Azure.AI.OpenAI;
using Microsoft.Mesh.CloudScripting;
using System.Numerics;
using System.Text.Json;
using WeatherAPI;

namespace CloudScripting.Sample
{
    /// <summary>
    /// Cloud app which displays weather information on a 3D globe and allows a user to chat with a LLM about the weather.
    /// </summary>
    public class App : IHostedService, IAsyncDisposable
    {
        private readonly ICloudApplication _app;
        private readonly ILogger<App> _logger;

        private readonly string? _weatherAPIBaseUrl;
        private readonly string? _weatherAPIKey;
        private OpenAIClient _openAIClient;

        private string[] _latlong = new string[] { "6.465422,3.406448",     // Lagos, Nigeria
                                                   "47.673988,-122.121513", // Redmond, WA, USA
                                                   "53.349804,-6.260310" }; // Dublin, Ireland
        private string _currentWeatherText = string.Empty;

        public App(ICloudApplication app, IConfiguration configuration, ILogger<App> logger)
        {
            _app = app;
            _logger = logger;

            _weatherAPIBaseUrl = configuration.GetValue<string>("WEATHER_API_URI");
            _weatherAPIKey = configuration.GetValue<string>("WEATHER_API_KEY");

            Uri azureOpenAIResourceUri = new(configuration.GetValue<string>("AZURE_OPENAI_API_URI"));
            AzureKeyCredential azureOpenAIApiKey = new(configuration.GetValue<string>("AZURE_OPENAI_API_KEY"));
            _openAIClient = new(azureOpenAIResourceUri, azureOpenAIApiKey);
        }

        /// <inheritdoc/>
        public Task StartAsync(CancellationToken token)
        {
            // When a user selects the globe, refresh the current weather
            // Paste code here

            // When a user selects the information button begin a conversation with a LLM
            var aiParentNode = _app.Scene.FindFirstChild("5 - AIAssistant", true) as TransformNode
                ?? throw new NullReferenceException("Could not find infoButtonParent");
            var infoButton = aiParentNode.FindFirstChild<InteractableNode>(true);

            if (infoButton != null)
            {
                infoButton.Selected += async (sender, args) =>
                {
                    // Ensure we have weather data before begining the conversation
                    await GetCurrentWeather(_latlong);

                    // Display an input dialog for the user to send a message to the LLM
                    // Paste code here
                };
            }

            // When a user selects the reset button, reset the weather markers
            var resetButton = _app.Scene.FindFirstChild("ResetWeatherButton", true) as TransformNode
                ?? throw new NullReferenceException("Could not find ResetWeatherButton");
            var resetButtonNode = resetButton.FindFirstChild<InteractableNode>(true);

            if (resetButtonNode != null)
            {
                resetButtonNode.Selected += (_, _) =>
                {
                    var weatherMarkersGameObject = _app.Scene.FindFirstChild("WeatherMarkers", true) as TransformNode
                        ?? throw new NullReferenceException("Could not find WeatherMarkers");

                    // Hide all the weather markers
                    foreach (var child in weatherMarkersGameObject.Children)
                    {
                        child.IsActive = false;
                    }
                };
            }

            return Task.CompletedTask;
        }

        /// <inheritdoc/>
        public Task StopAsync(CancellationToken token)
        {
            return Task.CompletedTask;
        }

        /// <inheritdoc/>
        public async ValueTask DisposeAsync()
        {
            await StopAsync(CancellationToken.None).ConfigureAwait(false);

            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// Gets the weather for each lat long location.
        /// </summary>
        public async Task<CurrentWeather[]> GetCurrentWeather(string[] latlong)
        {
            var weatherData = new CurrentWeather[latlong.Length];
            for (int i = 0; i < latlong.Length; i++)
            {
                weatherData[i] = await GetCurrentWeatherData(latlong[i]);
                _currentWeatherText += " " + weatherData[i].GetFormattedWindDetails();
            }

            UpdateWeatherMarkers(weatherData);

            return weatherData;
        }

        /// <summary>
        /// Asks weatherapi.com for the current weather at the specified lat long.
        /// </summary>
        public async Task<CurrentWeather> GetCurrentWeatherData(string latlong)
        {
            var url = _weatherAPIBaseUrl + _weatherAPIKey + "&q=" + latlong;
            var _httpClient = new HttpClient();
            var response = await _httpClient.GetAsync(url);
            var content = await response.Content.ReadAsStringAsync();
            CurrentWeather weatherData = JsonSerializer.Deserialize<CurrentWeather>(content);

            return weatherData;
        }

        /// <summary>
        /// Format the text on the weather markers and place them on the 3D globe
        /// </summary>
        public void UpdateWeatherMarkers(CurrentWeather[] weatherData)
        {
            var weatherMarkersGameObject = _app.Scene.FindFirstChild("WeatherMarkers", true) as TransformNode
                ?? throw new NullReferenceException("Could not find WeatherMarkers");

            // Show all the weather markers in case they were hidden
            foreach (var child in weatherMarkersGameObject.Children)
            {
                child.IsActive = true;
            }

            // Loop through all the weather markers and update the text and position relative to globe
            var weatherMarkersLabel = weatherMarkersGameObject.FindAllChildren<TextNode>(true);

            for (int i = 0; i < weatherMarkersLabel.Count(); i++)
            {
                var current = weatherData[i].current;

                if (current != null)
                {
                    weatherMarkersLabel.ElementAt(i).Text = $"<b>{weatherData[i].location?.name}</b>\n<size=80%>{(int)current.temp_f}°F / {(int)current.temp_c}°C\n<size=70%>Wind Speed\n{current.wind_mph}mph / {current.wind_kph}kph";
                }

                // We assume the root of the weather marker is a child of the weatherMarkersGameObject
                var anchor = weatherMarkersGameObject.Children.ElementAt(i) as TransformNode;

                if (anchor != null)
                {
                    var latlon = ParseLatLon(_latlong[i]);

                    // Place the marker on the globe's surface
                    anchor.Position = PositionFromLatLon(latlon);

                    // Rotate the marker to face away from the globe's center
                    anchor.Rotation = Quaternion.CreateFromAxisAngle(Vector3.UnitY, MathF.Abs(latlon.Y - MathF.PI / 2));
                }
            }
        }

        /// <summary>
        /// Turn a lat long string into a Vector2 in radians.
        /// </summary>
        public static Vector2 ParseLatLon(string latLong, float latitudeOffset = 0, float longitudeOffset = 90)
        {
            // Convert string to float
            string[] latLongSplit = latLong.Split(',');
            float latitude = float.Parse(latLongSplit[0]) + latitudeOffset;
            float longitude = float.Parse(latLongSplit[1]) + longitudeOffset;

            // Transfer from degrees to radians
            float latitudeRad = latitude * (MathF.PI / 180);
            float longitudeRad = longitude * (MathF.PI / 180);

            return new Vector2(latitudeRad, longitudeRad);
        }

        /// <summary>
        /// Get the 3D position on the globe from the latitude and longitude
        /// </summary>
        public static Vector3 PositionFromLatLon(Vector2 latLong, float radius = 1)
        {
            // Polar to cartesian conversion
            float x = radius * MathF.Cos(latLong.X) * MathF.Cos(latLong.Y);
            float y = radius * MathF.Sin(latLong.X);
            float z = radius * MathF.Cos(latLong.X) * MathF.Sin(latLong.Y);

            return new Vector3(x, y, z);
        }
    }
}