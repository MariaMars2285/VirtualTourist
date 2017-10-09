//
//  BaseViewController.swift
//  VirtualTourist
//
//  Created by Maria  on 10/9/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import MapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension BaseViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "PinAnnotation")
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PinAnnotation")
        } else {
            view?.annotation = annotation
        }
        return view
    }
}
