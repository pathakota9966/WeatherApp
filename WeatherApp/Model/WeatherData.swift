//
//  WeatherData.swift
//  WeatherApp
//
//  Created by apple on 27/02/21.
//

import Foundation


struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Codable {
    let temp: Double
    let humidity: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}


struct Wind : Codable {
    let speed: Double
}

struct WeatherForecastData: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let dt_txt:String
    
    var temperatureString: String {
        return String(format: "%.1f", main.temp)
    }
    
    var conditionName: String {
        switch weather[0].id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}

struct ForecastData: Codable  {
    let city: City
    let list: [WeatherForecastData]
}

struct City : Codable {
    let name : String
}
