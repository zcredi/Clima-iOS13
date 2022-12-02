//
//  WeatherData.swift
//  Clima
//
//  Created by Владислав on 01.12.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherDate: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
