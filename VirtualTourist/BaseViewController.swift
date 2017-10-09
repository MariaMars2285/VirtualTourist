//
//  BaseViewController.swift
//  VirtualTourist
//
//  Created by Maria  on 10/9/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import MapKit
import CoreData

class BaseViewController: UIViewController {

    public var stack: CoreDataStack {
        get {
            let app = UIApplication.shared.delegate as! AppDelegate
            return app.stack
        }
    }
    
    public var context: NSManagedObjectContext {
        get {
            return stack.context
        }
    }
 
    func showErrorAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
