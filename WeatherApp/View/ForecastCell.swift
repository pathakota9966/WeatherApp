//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by apple on 28/02/21.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var climateImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var forecastCellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(_ forecastWeather:WeatherForecastData){
        dateLabel.text = "\(forecastWeather.dt_txt.replacingOccurrences(of: "2021-", with: ""))"
        self.temp.text = "T:\(forecastWeather.temperatureString)"
        self.humidity.text = "H:\(forecastWeather.main.humidity)"
        self.wind.text = "W:\(forecastWeather.wind.speed)"
        self.climateImage.image = UIImage(systemName: "\(forecastWeather.conditionName)")
        descriptionLabel.text = "\(forecastWeather.weather[0].description)"
    }

}
