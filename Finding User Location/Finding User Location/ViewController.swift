//
//  ViewController.swift
//  Finding User Location
//
//  Created by Sean Higgins on 6/20/19.
//  Copyright © 2019 Sean Higgins. All rights reserved.
//

//
// Added CoreLocation.framework to Build Phase on startup
// Added - "Privacy - Location When In Use Usage Description" to Info.plist with description as to why.
// Added - "Privacy - Location Always Usage Description" to Info.plist with description.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

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
    
    @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let user_location: CLLocation = locations[0]
        
        let latitude = user_location.coordinate.latitude
        let longitude = user_location.coordinate.longitude
        
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
        
        // add annotations to the map
        let annotation = MKPointAnnotation()
        annotation.title = "User Location"
        annotation.subtitle = "Simulated user location."
        annotation.coordinate = location
        map.addAnnotation(annotation)
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

