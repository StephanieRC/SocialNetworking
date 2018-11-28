//
//  MapGoogleViewController.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/28/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import GoogleMaps

class MapGoogleViewController: UIViewController {

    @IBOutlet weak var uiview: GMSMapView!
    var userArr: [(User, Bool)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiview.mapType = .satellite
        createMarker(userInfo: userArr)
    }
    
    func createMarker(userInfo: [(User, Bool)]){
        for ui in userInfo{
            let user = ui.0
            let lat = Double(user.lat)
            let lon = Double(user.lon)
            let location = CLLocation(latitude: lat ?? 0.0, longitude: lon ?? 0.0)
            //        let latitude = String(format: "%f", location.coordinate.latitude)
            //        let longitude = String(format: "%f", location.coordinate.longitude)
            let marker = GMSMarker()
            marker.position = location.coordinate
            marker.title = user.displayName
            marker.map = uiview
            marker.isDraggable = false
            let smallImg = UIImage().resizeimage(image: user.img!, withSize: CGSize(width: 60.0, height: 60.0))
            marker.icon = smallImg
        }
//        uiview.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 25)
    }
    
}
