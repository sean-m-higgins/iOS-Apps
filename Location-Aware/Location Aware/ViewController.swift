//
//  ViewController.swift
//  Location Aware
//
//  Created by Sean Higgins on 6/20/19.
//  Copyright © 2019 Sean Higgins. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var latitude_label: UILabel!
    @IBOutlet weak var longitude_label: UILabel!
    @IBOutlet weak var course_label: UILabel!
    @IBOutlet weak var speed_label: UILabel!
    @IBOutlet weak var altitude_label: UILabel!
    @IBOutlet weak var address_label: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    var location_manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        location_manager.delegate = self
        location_manager.desiredAccuracy = kCLLocationAccuracyBest
        location_manager.requestWhenInUseAuthorization()
        location_manager.startUpdatingLocation()
        
        //user annotations via long press on screen
        let ui_lpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.long_press(gesture_recognizer:)))
        ui_lpgr.minimumPressDuration = 2
        map.addGestureRecognizer(ui_lpgr)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        let user_location: CLLocation = locations[0]
        
        let latitude = user_location.coordinate.latitude
        let longitude = user_location.coordinate.longitude

        let latDelta: CLLocationDegrees = 0.005
        let longDelta: CLLocationDegrees = 0.005
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = "User Location"
        annotation.subtitle = "Simulated user location."
        annotation.coordinate = location
        map.addAnnotation(annotation)
        
        self.latitude_label.text = String(latitude)
        self.longitude_label.text = String(longitude)
        self.course_label.text = String(user_location.course)
        self.speed_label.text = String(user_location.speed)
        self.altitude_label.text = String(user_location.altitude)
        
        CLGeocoder().reverseGeocodeLocation(user_location) { (placemarks, error) in
            if error != nil {
                print(error!)
            } else {
                if let location_information = placemarks?[0] {
                    
                    var address = ""
                    
                    if location_information.subThoroughfare != nil {
                        address += location_information.subThoroughfare! + " "
                    }
                    
                    if location_information.thoroughfare != nil {
                        address += location_information.thoroughfare! + " "
                    }
                    
                    if location_information.subLocality != nil {
                        address += location_information.subLocality! + " "
                    }
                    
                    if location_information.subAdministrativeArea != nil {
                        address += location_information.subAdministrativeArea! + " "
                    }
                    
                    if location_information.postalCode != nil {
                        address += location_information.postalCode! + " "
                    }
                    
                    if location_information.country != nil {
                        address += location_information.country! + " "
                    }
                    
                    self.address_label.text = String(address)
                }
            }
        }
    }
    
    // use a long press to create a new annotation on the map
    @objc func long_press(gesture_recognizer: UIGestureRecognizer) {
        let touch_point = gesture_recognizer.location(in: self.map)
        let coordinate = map.convert(touch_point, toCoordinateFrom: self.map)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "New place"
        map.addAnnotation(annotation)
    }
}

