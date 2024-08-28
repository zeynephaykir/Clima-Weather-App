//
//  WeatherManager.swift
//  Clima
//
//  Created by Zeynep HAYKIR on 2024-08-12.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    private var apiKey: String {
            guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
                  let config = NSDictionary(contentsOfFile: path),
                  let key = config["API_KEY"] as? String else {
                return "default_key"  // Use a fallback or handle the error
            }
            return key
        }

        private var weatherURL: String {
            return "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
        }
    
    
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //  1.Create a URL
        if let url = URL(string: urlString){
            
            //  2.Create a URLSession
            let session = URLSession(configuration: .default)
            
            //  3.Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    //print(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //  4.Start the task
            task.resume()
        }
        
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            
            return weather
            //print(weather.conditionName)
            //print(weather.temperatureString)
        } catch {
            delegate?.didFailWithError(error: error)
            //print(error)
            return nil
        }
    }
    
    
}
