//
//  WeatherConfiguration.swift
//  ThisWeek
//
//  Created by Emanuel on 14/07/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import Foundation


class WeatherConfiguration{
    struct Defaults{
        static let Latitude : Double = -34.7667
        static let Longitude : Double = -58.4
    }
}


struct WeatherAPI {
    static let APIKey = "&appid=7ddc38eaf9064f7b678f98c01698f3bd"
    static let BaseURL = "https://api.openweathermap.org/data/2.5/onecall?exclude=current,hourly,minutely&units=metric"
    static var authenticatedBaseURL : URL{
        return URL(string: BaseURL + APIKey)!
    }
}
