//
//  WeatherDataManager.swift
//  ThisWeek
//
//  Created by Emanuel on 14/07/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import Foundation

enum DataManagerError: Error {

    case Unknown
    case FailedRequest
    case InvalidResponse

}

class WeatherDataManager{
    
    typealias WeatherDataCompletion = (WeatherClass?, DataManagerError?) -> ()
    
    let baseURL : URL
    
    init(baseURL : URL){
        self.baseURL = baseURL
    }
    
    func weatherDataForLocation(latitude: Double, longitude: Double, completion: @escaping WeatherDataCompletion) {
        
        // Create URL
        let wURL = URL(string: baseURL.absoluteString + "&lat=\(latitude)&lon=\(longitude)" )

        // Create Data Task
        URLSession.shared.dataTask(with: wURL!) { (data, response, error) in
            self.didFetchWeatherData(data: data, response: response, error: error, completion: completion)
            }.resume()

    }
    
    private func didFetchWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: WeatherDataCompletion) {
        if let _ = error {
            completion(nil, .FailedRequest)

        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                processWeatherData(data: data, completion: completion)
            } else {
                completion(nil, .FailedRequest)
            }
        } else {
            completion(nil, .Unknown)
        }
    }
    
    private func processWeatherData(data: Data, completion: WeatherDataCompletion) {
        if let JSON = try? JSONDecoder().decode(WeatherClass.self, from: data){
            completion(JSON, nil)
        } else {
            completion(nil, .InvalidResponse)
        }
    }
}
