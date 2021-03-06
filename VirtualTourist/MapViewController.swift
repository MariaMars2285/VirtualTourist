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

//Represents 2 states of the map view. Adding state when you can add pin and deleting state for delete pin.
enum MapViewControllerState {
    case add
    case delete
}

class MapViewController: BaseViewController {

    @IBOutlet weak var bottomLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: MKMapView!
    
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
        bottomLabelConstraint.constant = 0
    }
    
    func hideDeleteLabel() {
        bottomLabelConstraint.constant = 65
    }
    
    // Checks the state and deletes/hide the delete label based on state.
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
    
    // Adds Annotation based on Long press
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
    
    //Deletes Annotation from map as well as Core Data.
    func deleteAnnotation(_ annotation: Location) {
        mapView.removeAnnotation(annotation)
        stack.context.delete(annotation)
    }

}

extension MapViewController {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
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
