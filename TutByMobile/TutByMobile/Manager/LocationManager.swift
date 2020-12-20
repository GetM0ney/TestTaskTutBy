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
        
        var b = 1
        var c = 1
        
        if b == c {
            print("1")
        } else {
            print("2")
        }
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
                print("not by")
            }  else {
                self.delegate?.updateUI(status: false)
                print("by")
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


