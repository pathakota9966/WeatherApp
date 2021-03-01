//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by apple on 27/02/21.
//

import Foundation


struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let humidity : Double
    let wind : Double
    let description: String
    let isMetric : Bool
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
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

struct WeatherForecastModel {
    let city : City
    let weatherList : [WeatherForecastData]
}
