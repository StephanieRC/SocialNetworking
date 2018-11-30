//
//  MapGoogleViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/28/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import GoogleMaps

let RECTNOTEZoomOut: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40)
let RECTNOTEZoomIn: CGRect = CGRect(x: 0, y: 0, width: 80, height: 80)

class MapGoogleViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var uiview: GMSMapView!
    var selectedMarker: GMSMarker?
    
    var userArr: [(User, Bool)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiview.delegate = self
        uiview.mapType = .satellite
        showUsersLocation(userInfo: userArr)
    }
    

    @IBAction func backBarBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let marker = selectedMarker {
            marker.iconView!.frame = RECTNOTEZoomOut
            marker.iconView!.layer.cornerRadius = 40/2
            marker.iconView!.layer.masksToBounds = false
            marker.iconView!.clipsToBounds = true
        }
        if let ImageView = marker.iconView as? UIImageView{
            selectedMarker = marker
            ImageView.frame = RECTNOTEZoomIn
            ImageView.layer.cornerRadius = 80/2
            ImageView.layer.masksToBounds = false
            ImageView.clipsToBounds = true
            self.uiview.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 17)
            
        }
        
        return true
    }
    
    func showUsersLocation(userInfo: [(User, Bool)]) {
        
        for ui in userInfo {
            let user = ui.0
            let coordinateLatitude = Double(user.lat)
            let coordinateLongitude = Double(user.lon)
            let location = CLLocation(latitude: coordinateLatitude ?? 0.0, longitude: coordinateLongitude ?? 0.0)
            
            DispatchQueue.main.async {
                let marker = GMSMarker()
                marker.position = location.coordinate
                marker.title = user.displayName
                let imgView = UIImageView(frame: RECTNOTEZoomOut)
                imgView.layer.borderWidth = 2
                imgView.layer.borderColor = UIColor.orange.cgColor
                imgView.layer.cornerRadius = imgView.frame.height/2
                imgView.layer.masksToBounds = false
                imgView.clipsToBounds = true
                imgView.image = user.img!
                marker.iconView = imgView
                marker.map = self.uiview
                
                self.uiview.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
            }
            
        }
    }
    
}
//
//func createMarker(userInfo: [(User, Bool)]){
//    for ui in userInfo{
//        let user = ui.0
//        let lat = Double(user.lat)
//        let lon = Double(user.lon)
//        let location = CLLocation(latitude: lat ?? 0.0, longitude: lon ?? 0.0)
//        //        let latitude = String(format: "%f", location.coordinate.latitude)
//        //        let longitude = String(format: "%f", location.coordinate.longitude)
//        let marker = GMSMarker()
//        marker.position = location.coordinate
//        marker.title = user.displayName
//        marker.map = uiview
//        marker.isDraggable = false
//        let smallImg = UIImage().resizeimage(image: user.img!, withSize: CGSize(width: 60.0, height: 60.0))
//        marker.icon = smallImg
//    }
//    //        uiview.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 25)
//}
