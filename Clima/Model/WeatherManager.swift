//
//  WeatherManager.swift
//  Clima
//
//  Created by Slava Pashaliuk on 3/29/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=f4da058814312ca7c78b4b99fd544c04"
    
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(_ cityName: String) {
        let sanitizedCityName = cityName.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(weatherURL)&q=\(sanitizedCityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(lat: Double, lon: Double) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: {
                if $2 != nil {
                    self.delegate?.didFailWithError(error: $2!)
                    return
                }
                
                if let safeData = $0 {
//                    let dataStr = String(data: safeData, encoding: .utf8)
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)

                    }
                }
            })
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            return WeatherModel(conditionId: decodedData.weather[0].id, cityName: decodedData.name, temperature: decodedData.main.temp)
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

