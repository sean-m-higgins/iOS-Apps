//
//  MapViewController.swift
//  Memorable-Places
//
//  Created by Sean Higgins on 6/21/19.
//  Copyright © 2019 Sean Higgins. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var location_manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let ui_lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.longpress(gestureRecognizer:)))
        ui_lpgr.minimumPressDuration = 1.5
        map.addGestureRecognizer(ui_lpgr)
        
        // when user clicks "plus" to add new place, go to user location
        if active_place == -1 {
            location_manager.delegate = self
            location_manager.desiredAccuracy = kCLLocationAccuracyBest
            location_manager.requestWhenInUseAuthorization()
            location_manager.startUpdatingLocation()
            
        } else {
            if global_places.count > active_place {
                if let name = global_places[active_place]["name"] {
                    if let lat = global_places[active_place]["latitude"] {
                        if let lon = global_places[active_place]["longitude"] {
                            let latitude = Double(lat)!
                            let longitude = Double(lon)!
                            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            let region = MKCoordinateRegion(center: coordinate, span: span)
                            self.map.setRegion(region, animated: true)
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = coordinate
                            annotation.title = name
                            self.map.addAnnotation(annotation)
                        }
                    }
                }
            }
        }
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touch_point = gestureRecognizer.location(in: self.map)
            let new_coordinate = self.map.convert(touch_point, toCoordinateFrom: self.map)
            
            let CL_coordinate = CLLocation(latitude: new_coordinate.latitude, longitude: new_coordinate.longitude)
            
            // reverse discover address from coordinates
            var title = ""
            CLGeocoder().reverseGeocodeLocation(CL_coordinate, completionHandler: { (placemarks, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    if let location_info = placemarks?[0] {
                        if location_info.subThoroughfare != nil {
                            title += location_info.subThoroughfare! + " "
                        }
                        if location_info.thoroughfare != nil {
                           title += location_info.thoroughfare!
                        }
                    }
                }
        
                if title == "" {
                    title = "Added \(NSDate())"
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = new_coordinate
                annotation.title = title
                self.map.addAnnotation(annotation)
                
                global_places.append(["name": title, "latitude": String(new_coordinate.latitude), "longitude": String(new_coordinate.longitude)])
                
                UserDefaults.standard.set(global_places, forKey: "places")
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
