//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Maria  on 10/5/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import MapKit
import CoreData

enum MapViewControllerState {
    case add
    case delete
}

class MapViewController: BaseViewController {

    @IBOutlet weak var bottomLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var stack: CoreDataStack {
        get {
            let app = UIApplication.shared.delegate as! AppDelegate
            return app.stack
        }
    }
    
    private var state = MapViewControllerState.add
    private var selectedLocation: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        
        do {
            let results = try stack.context.fetch(request)
            for location in results {
                mapView.addAnnotation(location)
            }
        } catch {
            
        }
    }
    
    func showDeleteLabel() {
        bottomLabelConstraint.constant = 65
    }
    
    func hideDeleteLabel() {
        bottomLabelConstraint.constant = 0
    }
    
    @IBAction func editClick(sender: UIBarButtonItem!) {
        if state == .add {
            state = .delete
            sender.title = "Done"
            showDeleteLabel()
        } else {
            state = .add
            sender.title = "Edit"
            hideDeleteLabel()
        }
    
    }
    
    @IBAction func onMapViewLongPress(sender: UIGestureRecognizer!) {
        
        if sender.state == .recognized && state == .add {
            print("long press")
            let point = sender.location(in: mapView)
            print(point)
            let coordinate = mapView.convert(point, toCoordinateFrom: nil)
            print(mapView.region)
            print(coordinate)
            let annotation = Location(latitude: coordinate.latitude, longitude: coordinate.longitude, context: stack.context)
            stack.save()
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func deleteAnnotation(_ annotation: Location) {
        mapView.removeAnnotation(annotation)
        stack.context.delete(annotation)
    }

}

extension MapViewController {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? Location {
            if state == .delete {
               deleteAnnotation(annotation)
            } else {
                selectedLocation = annotation
                self.performSegue(withIdentifier: "ShowDetail", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AlbumViewController
        vc.location = selectedLocation
    }
}
