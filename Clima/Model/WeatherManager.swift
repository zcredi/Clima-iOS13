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
        print(urlString)
    }
    
    func performRequest(urlString: String) {
        
        // 1. Создайте URL-адрес
        if let url = URL(string: urlString) {
            
            //2. Создайте сеанса URL-адреса
            let session = URLSession(configuration: .default)
            
            //3. Даем сеансу задание
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            //4. Запускаем задачу
            task.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString)
        }
    }
}
