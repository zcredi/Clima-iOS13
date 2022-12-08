//
//  WeatherManager.swift
//  Clima
//
//  Created by Владислав on 28.11.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

// Сруктура получения API погоды

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=73d1c1463c515bb8009159dda71a486f&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        
    }
    
    func fetchWather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
        
        func performRequest(with urlString: String) {
            
            // 1. Создайте URL-адрес
            if let url = URL(string: urlString) {
                
                //2. Создайте сеанса URL-адреса
                let session = URLSession(configuration: .default)
                
                //3. Даем сеансу задание
                let task = session.dataTask(with: url) { data, response, error in
                    if error != nil {
                        delegate?.didFailWithError(error: error!)
                        return
                    }
                    if let safeData = data {
                        if let weather = self.parseJSON(safeData) {
                            self.delegate?.didUpdateWeather(self, weather: weather)
                            
                        }
                    }
                }
                
                //4. Запускаем задачу
                task.resume()
            }
        }
        
        func parseJSON(_ weatherData: Data) -> WeatherModel? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(WeatherDate.self, from: weatherData)
                let id = decodedData.weather[0].id
                let temp = decodedData.main.temp
                let name = decodedData.name
                
                let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
                return weather
            } catch {
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
    }
