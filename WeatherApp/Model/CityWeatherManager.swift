//
//  CityWeatherManager.swift
//  WeatherApp
//
//  Created by apple on 27/02/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: CityWeatherManager, weather: WeatherModel)
    func didUpdateWeatherForecast(_ weatherManager:CityWeatherManager, weatherForecast:WeatherForecastModel)
    func didFailWithError(error: Error)
}

struct CityWeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=a2a59168aa12a16bc4b6e05b5a1223eb"
    
    let weatherForecastURL = "https://api.openweathermap.org/data/2.5/forecast?appid=a2a59168aa12a16bc4b6e05b5a1223eb"

    var delegate: WeatherManagerDelegate?
    
    func isMetricUnitsEnabled() -> Bool {
        var isMetricEnabled = true
        if UserDefaults.standard.value(forKey: "switchON") != nil{
            let switchON: Bool = UserDefaults.standard.value(forKey: "switchON")  as! Bool
            if switchON == false {
                isMetricEnabled = false
            }
        }
        return isMetricEnabled
    }
    
    func fetchWeather(cityName: String) {

        if isMetricUnitsEnabled() {
            let urlString = "\(weatherURL)&q=\(cityName)&units=metric"
            performRequest(with: urlString, isForecast: false)
        }else {
            let urlString = "\(weatherURL)&q=\(cityName)&units=imperial"
            performRequest(with: urlString, isForecast: false)
        }

    }
    
    func fetchWeatherForecast(cityName: String){
        if isMetricUnitsEnabled(){
            let urlString = "\(weatherForecastURL)&q=\(cityName)&units=metric"
            performRequest(with: urlString, isForecast: true)
        }else{
            let urlString = "\(weatherForecastURL)&q=\(cityName)&units=imperial"
            performRequest(with: urlString, isForecast: true)
        }
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString, isForecast: false)
    }
    
    func performRequest(with urlString: String, isForecast:Bool) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if isForecast {
                        if let weather = self.parseForecastJSON(safeData) {
                            self.delegate?.didUpdateWeatherForecast(self, weatherForecast: weather)
                        }
                    }else {
                        if let weather = self.parseJSON(safeData) {
                            self.delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
            }
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
            let humidity = decodedData.main.humidity
            let wind = decodedData.wind.speed
            let desc = decodedData.weather[0].description
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, humidity: humidity, wind: wind, description: desc, isMetric: isMetricUnitsEnabled())
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func parseForecastJSON(_ weatherData: Data) -> WeatherForecastModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ForecastData.self, from: weatherData)
            let cityDic = decodedData.city
            let forecastList = decodedData.list as [WeatherForecastData]
            let forecastweather = WeatherForecastModel(city: cityDic, weatherList: forecastList)
            return forecastweather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}




