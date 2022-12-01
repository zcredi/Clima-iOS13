//
//  WeatherManager.swift
//  Clima
//
//  Created by Владислав on 28.11.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

// Сруктура получения API погоды

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=73d1c1463c515bb8009159dda71a486f&units=metric"
    
    func fetchWather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        
        // 1. Создайте URL-адрес
        if let url = URL(string: urlString) {
            
            //2. Создайте сеанса URL-адреса
            let session = URLSession(configuration: .default)
            
            //3. Даем сеансу задание
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            
            //4. Запускаем задачу
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
           let decodedData = try decoder.decode(WeatherDate.self, from: weatherData)
            print(decodedData.weather[0].description)
        } catch {
            print(error)
        }
    }
}
