//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    // Экземпляр структуры с API погоды
    var weatherManager = WeatherManager()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    // Срабатывает если пользователь ничего не ввел в поле Search
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            textField.placeholder = "Введите что-нибудь"
            return false
        }
    }
    
    // После нажатия на поиск или ГО на клавиатуре, поле сбрасывается на пустое
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

