//
//  ViewController.swift
//  WeatherApp
//
//  Created by apple on 27/02/21.
//

import UIKit
import MapKit
class ViewController: UIViewController {
    var bookmarkedCityList = ["Chennai","Hyderabad","London","Bangalore","California"]
    
    @IBOutlet weak var homeView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCities: [String] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.delegate = self
        self.title = "Bookmarked Locations"
        homeView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCellId")
        let defaults = UserDefaults.standard

        let savedArray = defaults.object(forKey: "BookmarkedCities") as? [String] ?? [String]()
        if savedArray.count > 0 {
            bookmarkedCityList = savedArray
        }else {
            defaults.set(bookmarkedCityList, forKey: "BookmarkedCities")
        }
        defaults.synchronize()
        let buttonIcon = UIImage(named: "hamburgerIcon")
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUserLocation))
        let leftBarButton = UIBarButtonItem(title: "<<", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.myLeftSideBarButtonItemTapped(_:)))
                leftBarButton.image = buttonIcon
                
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = addBarButton
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Cities"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        homeView.reloadData()
    }
    
    @objc func myLeftSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
     {
         print("myLeftSideBarButtonItemTapped")
        let settingsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewControllerID") as! SettingsViewController
//        settingsView.addLocationDelegate = self
//        self.navigationController?.pushViewController(settingsView, animated: true)
        self.present(settingsView, animated: true, completion: nil)
        
     }

    @objc private func addUserLocation() {
        let weatherView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewControllerID") as! MapViewController
        weatherView.addLocationDelegate = self
        self.navigationController?.pushViewController(weatherView, animated: true)
    }

    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        filteredCities = bookmarkedCityList.filter ({
            $0.lowercased().contains(searchText.lowercased())
        })
      
        homeView.reloadData()
    }


}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
          return filteredCities.count
        }
        return bookmarkedCityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cityCellId"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if isFiltering {
            cell.textLabel?.text = filteredCities[indexPath.row]
        }else{
            cell.textLabel?.text = bookmarkedCityList[indexPath.row]
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            bookmarkedCityList.remove(at: indexPath.row)
            homeView.deleteRows(at: [indexPath], with: .fade)
            let defaults = UserDefaults.standard
            defaults.set(bookmarkedCityList, forKey: "BookmarkedCities")
            defaults.synchronize()
        }
    }
    
    
}
extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let weatherView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CityWeatherViewController") as! CityWeatherViewController
        weatherView.city = bookmarkedCityList[indexPath.row]
        
//        let weatherView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewControllerID") as! MapViewController
//        weatherView.addLocationDelegate = self

        self.navigationController?.pushViewController(weatherView, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating {
    
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

extension ViewController : AddLocationDelegate {
    func didAddLocationName(_ locaitonName: String) {
        let defaults = UserDefaults.standard
        var savedArray = defaults.object(forKey: "BookmarkedCities") as? [String] ?? [String]()
        if savedArray.count > 0 && !savedArray.contains(locaitonName) {
            savedArray.append(locaitonName)
            defaults.set(savedArray, forKey: "BookmarkedCities")
            defaults.synchronize()
        }
        

        if !bookmarkedCityList.contains(locaitonName) {
            bookmarkedCityList.append(locaitonName)
            homeView.reloadData()
        }
    }
}
