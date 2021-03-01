//
//  MapViewController.swift
//  WeatherApp
//
//  Created by apple on 28/02/21.
//

import UIKit
import MapKit
import CoreLocation

protocol AddLocationDelegate {
    func didAddLocationName(_ locaitonName: String)
}

class MapViewController: UIViewController,MKMapViewDelegate {
    var addLocationDelegate: AddLocationDelegate?

    @IBOutlet weak var mapView: MKMapView!
    
    var keyLat:String = "17.3850"
    var keyLon:String = "78.4867"
    var loadingAlert:UIAlertController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        longPressRecogniser.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressRecogniser)
        
        mapView.mapType = MKMapType.standard
        
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(keyLat.toFloat()),longitude: CLLocationDegrees(keyLon.toFloat()))
        
        let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Hyderabad"
        annotation.subtitle = "Hyderabad Telangana"
        mapView.addAnnotation(annotation)
    }



    
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer)
    {
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "latitude:" + String(format: "%.02f",annotation.coordinate.latitude) + "& longitude:" + String(format: "%.02f",annotation.coordinate.longitude)
        mapView.addAnnotation(annotation)
        _ = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)

        let myLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)

        resolveLocationName(with: myLocation) { [self] locationName in
            print("selected location is ===> \(String(describing: locationName))")
            showAlertToBookmarkLocation(_with: locationName!)
            addLocationDelegate?.didAddLocationName(locationName!)
        }
    }
    
    func showAlertToBookmarkLocation(_with locationName:String){
    
        let defaults = UserDefaults.standard
        let savedArray = defaults.object(forKey: "BookmarkedCities") as? [String] ?? [String]()
        if savedArray.count > 0 && !savedArray.contains(locationName) {
            self.loadingAlert = UIAlertController(title: "Alert", message: "Would you like to bookmark this location to check Weather details?", preferredStyle: .alert)
            self.loadingAlert?.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
                addLocationDelegate?.didAddLocationName(locationName)
            }))
            
            self.loadingAlert?.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(self.loadingAlert!, animated: true)
            defaults.synchronize()
        }else{
            print("\(locationName) is already there.")
        }
    }
    
    
    var selectedAnnotation: MKPointAnnotation?
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let latValStr : String = String(format: "%.02f",Float((view.annotation?.coordinate.latitude)!))
        let lonvalStr : String = String(format: "%.02f",Float((view.annotation?.coordinate.longitude)!))
        print("latitude: \(latValStr) & longitude: \(lonvalStr)")

        }
    
    
    public func resolveLocationName(with location: CLLocation, completion:@escaping ((String?) -> Void)){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) {
            placemarks, error in
            guard let place = placemarks?.first, error == nil else{
                completion(nil)
                return
            }
            var name = ""
            if let locality = place.locality {
                name += locality
            }
            /*if let adminLocality = place.administrativeArea{
                name += ", \(adminLocality)"
            }*/
            completion(name)
        }
    }

}

// Extend String with Two functions for converting Float and Double to string
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    func toFloat() -> Float {
        return (self as NSString).floatValue
    }
}

