//
//  CityWeatherViewController.swift
//  WeatherApp
//
//  Created by apple on 27/02/21.
//

import UIKit
import CoreLocation

class CityWeatherViewController: UIViewController {
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var wind: UILabel!
    
    @IBOutlet weak var climateDescription: UILabel!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    var city:String? = "Hyderabad"
    var weatherManager = CityWeatherManager()
    let locationManager = CLLocationManager()
    var weatherForecast3HourList:[WeatherForecastData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "City Weather details"
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        weatherManager.delegate = self

        //locationManager.requestLocation()
        forecastCollectionView.register(UINib.init(nibName: "ForecastCell", bundle: nil), forCellWithReuseIdentifier: "ForecastCellID")
        
        forecastCollectionView.dataSource = self
        forecastCollectionView.delegate = self
        
        weatherManager.fetchWeather(cityName: city!)
        weatherManager.fetchWeatherForecast(cityName: city!)

    }

}
//MARK: - WeatherManagerDelegate

extension CityWeatherViewController : WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: CityWeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = (weather.isMetric) ? "Temperature :  \(weather.temperatureString) °C" : "Temperature :  \(weather.temperatureString) °F"
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.humidity.text = "Humidity : \(weather.humidity) %"
            self.wind.text = "Wind Speed : \(weather.wind) km/h"
            self.climateDescription.text = "\(weather.description)"
        }
    }
    
    func didUpdateWeatherForecast(_ weatherManager: CityWeatherManager, weatherForecast: WeatherForecastModel) {
        DispatchQueue.main.async { [self] in
            self.cityLabel.text = weatherForecast.city.name
            print("count is ==> \(weatherForecast.weatherList.count)")
            if weatherForecast.weatherList.count > 0 {
                weatherForecast3HourList = weatherForecast.weatherList
                forecastCollectionView.reloadData()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UICollectionViewDataSource

extension CityWeatherViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherForecast3HourList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCellID", for: indexPath) as! ForecastCell
        cell.forecastCellView.layer.cornerRadius = 5.0
        if let forecastWeather = weatherForecast3HourList?[indexPath.row] {
            cell.configureWith(forecastWeather)
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CityWeatherViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100, height: 100)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.init(0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.init(0.0)
    }
}


extension CityWeatherViewController : UICollectionViewDelegate {
    
}

//MARK: - CLLocationManagerDelegate


extension CityWeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}






