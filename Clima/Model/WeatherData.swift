//
//  WeatherData.swift
//  Clima
//
//  Created by Zeynep HAYKIR on 2024-08-14.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String 
    let id: Int
}
