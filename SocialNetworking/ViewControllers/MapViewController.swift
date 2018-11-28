//
//  MapViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/28/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

let ClientID = "FFII1E134N13UEJHPRWRLAWFGJLRJ3ML2BOTCHY1Z2SNDO1Y"
let ClientSecret = "R4IXNKID2UTXKQXFAFVNOVJ1VOZ3H5HMLI2ZQWN0THUPO0YW"
let FOURSQUARE_URL = "https://api.foursquare.com/v2/venues/search?near=%@&query=%@&client_id=%@&client_secret=%@&v=20130815"

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapApple: MKMapView!
    var locationmanager = CLLocationManager()
    let locarr = [
        ["title": "loc1", "lat": 40.6546, "lon": 52.432],
        ["title": "loc2", "lat": 4.6546, "lon": 50.432]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        //every other 30 meters
        mapApple.delegate = self
        locationmanager.distanceFilter = 30
        localSearchApi()
    }
    
    @IBAction func btnStartAct(_ sender: UIButton) {
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
//            locationmanager.startUpdatingLocation()
//        }
        createmyAnnotation()
    }
    
    func setupZoom(loc:CLLocation){
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: loc.coordinate, span: span)
        mapApple.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last{
            locationmanager.stopUpdatingLocation()
            //getCurrentCity(loc: loc)
        }
    }
    
    func localSearchApi(){
        //let loca = CLLocation(latitude: 44.34333, longitude: 32.98444)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Hotel"
        request.region = mapApple.region
        let search = MKLocalSearch(request: request)
        search.start { (response, err) in
            guard let res = response else{
                return
            }
            print(res.mapItems)
            for item in res.mapItems{
                let droppin = MKPointAnnotation()
                droppin.coordinate = item.placemark.coordinate
                droppin.title = item.placemark.locality ?? "test"
                self.mapApple.addAnnotation(droppin)
            }
            self.mapApple.showAnnotations(self.mapApple.annotations, animated: true)
        }
    }
    
    func createAnnotation(loc:CLLocation){
            let droppin = MKPointAnnotation()
            droppin.coordinate = loc.coordinate
            droppin.title = "Hello"
            mapApple.addAnnotation(droppin)
            setupZoom(loc: loc)
    }
    
    func createmyAnnotation(){
        for loc in locarr{
            let droppin = MKPointAnnotation()
            droppin.coordinate = CLLocationCoordinate2DMake(loc["lat"] as! CLLocationDegrees, loc["lon"] as! CLLocationDegrees)
            droppin.title = loc["title"] as? String
            mapApple.addAnnotation(droppin)
        }
        mapApple.showAnnotations(mapApple.annotations, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func getCurrentCity(loc: CLLocation){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(loc) { (placemarks, err) in
            if let placemark = placemarks?.last{
                let urlStr = String(format: FOURSQUARE_URL, placemark.locality ?? "Delhi", "Food", ClientID, ClientSecret)
                print(urlStr)
                print(placemark.country)
                print(placemark.locality)
                print(placemark.addressDictionary)
            }
        }
        
        geocoder.geocodeAddressString("new delhi") { (placemarks, err) in
            if let placemark = placemarks?.last{
                print(placemark.location?.coordinate)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let identifier = "MyPin"
        
        if !(annotation is MKPointAnnotation){
            return nil
        }
        
        var annotationview = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationview == nil{
            annotationview = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationview?.canShowCallout = true
        }else{
            annotationview?.annotation = annotation
        }
        annotationview?.image = UIImage(named: "mapmarker")
        
        return annotationview
    }
    
}
