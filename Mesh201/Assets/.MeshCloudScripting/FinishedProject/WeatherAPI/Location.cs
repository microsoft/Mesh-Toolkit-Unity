// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

namespace WeatherAPI
{
    public class Location
    {
        public string? name { get; set; }
        public string? region { get; set; }
        public string? country { get; set; }
        public float lat { get; set; }
        public float lon { get; set; }
        public string? tz_id { get; set; }
        public int localtime_epoch { get; set; }
        public string? localtime { get; set; }
    }
}