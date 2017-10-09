//
//  AlbumViewController.swift
//  VirtualTourist
//
//  Created by Maria  on 10/5/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import MapKit

class AlbumViewController: BaseViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var location: Location!

    override func viewDidLoad() {
        super.viewDidLoad()
        let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(location)
    }


}
