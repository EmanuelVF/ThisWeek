//
//  WeatherClass.swift
//  ThisWeek
//
//  Created by Emanuel on 14/07/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import Foundation
class WeatherClass: Decodable {
    let daily: [DailyDetail]
}

struct DailyDetail: Decodable{
    var dt : Int
    var weather : [WeatherInfo]
}

struct WeatherInfo : Decodable{
    var id : Int
    var main : String
}
