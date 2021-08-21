//
//  AppLocationManager.swift
//  Location Task
//
//  Created by Mac on 18/08/21.
//

import Foundation
import CoreLocation
import UIKit


class AppLocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = AppLocationManager()
    let locationManager : CLLocationManager
    var isSignificant = false
    

    override init() {
        locationManager = CLLocationManager()
        super.init()
    }

    func start() {
        isSignificant = false
        locationManager.delegate = nil
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()

    }
    
    func startSignificant() {
        isSignificant = true
        locationManager.delegate = nil
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
    }

    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            self.start()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isSignificant{
            self.locationManager.delegate = nil
        }

        guard let mostRecentLocation = locations.last else {
            return
        }
        print(mostRecentLocation)
        let info = LocationInformation()
        info.latitude = mostRecentLocation.coordinate.latitude
        info.longitude = mostRecentLocation.coordinate.longitude


        //now fill address as well for complete information through lat long ..
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(mostRecentLocation) { (placemarks, error) in
            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
            if let city = placemark.locality,
                let state = placemark.administrativeArea,
                let zip = placemark.postalCode,
                let locationName = placemark.name,
                let thoroughfare = placemark.thoroughfare,
                let country = placemark.country {
                info.city     = city
                info.state    = state
                info.zip = zip
                info.address =  locationName + ", " + (thoroughfare as String)
                info.country  = country
            }
            
            if !self.isSignificant{
                self.stop()
            }
            let strTitle =  "\(info.address ?? ""),\(info.city ?? ""),\(info.zip ?? "")"
            CoreDataManager.shared.insertIntoTable(strLocation:strTitle)

        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationManager.stopUpdatingLocation()
    }
}

class LocationInformation {
    var city:String?
    var address:String?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var zip:String?
    var state :String?
    var country:String?
    init(city:String? = "",address:String? = "",latitude:CLLocationDegrees? = Double(0.0),longitude:CLLocationDegrees? = Double(0.0),zip:String? = "",state:String? = "",country:String? = "") {
        self.city    = city
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.zip        = zip
        self.state = state
        self.country = country
    }
}
