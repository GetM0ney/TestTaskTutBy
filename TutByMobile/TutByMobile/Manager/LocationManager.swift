//
//  LocationManager.swift
//  TutByMobile
//
//  Created by Владимир Лишаненко on 11/17/20.

import UIKit
import CoreLocation

protocol LocationManagerDelegate {
    func updateUI(status: Bool)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    var delegate: LocationManagerDelegate?
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var placemarks = [CLPlacemark]()
    private var placeMark: CLPlacemark?
    
    func configure() {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func isCountryBY() {
        guard let location = locationManager.location else {
            return
        }
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil && placemarks!.count > 0 {
                self.placeMark = placemarks?.last
            }
            if self.placeMark!.isoCountryCode != "BY" {
                self.delegate?.updateUI(status: true)
            }  else {
                self.delegate?.updateUI(status: false)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         isCountryBY()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


