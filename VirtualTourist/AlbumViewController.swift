//
//  AlbumViewController.swift
//  VirtualTourist
//
//  Created by Maria  on 10/5/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import MapKit
import CoreData


class AlbumViewController: BaseViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var newCollectionButton: UIButton!
    
    var location: Location!
    var imageManager = ImageManager()
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths : [IndexPath]!
    var updatedIndexPaths : [IndexPath]!
    
    //Fetch Results Controller for images corresponding to the location.
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Image> in
        let fetchRequest = NSFetchRequest<Image>(entityName: "Image")
        fetchRequest.predicate = NSPredicate(format: "location == %@", self.location)
        fetchRequest.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the region for the map.
        let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(location)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error")
        }
        if !location.loaded {
            downloadLocationImages()
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.collectionView.reloadData()
    }
    
    //Fetches image URLs from Flickr
    func downloadLocationImages() {
        location.loaded = false
        newCollectionButton.isEnabled = false
        imageManager.getFlickrImages(forLocation: location) { (images, error) in
            self.newCollectionButton.isEnabled = true
            guard error == nil else {
                self.showErrorAlert(title: "Error", message: "Error Downloading Images from Flickr!")
                return
            }
            
            guard let images = images else {
                self.showErrorAlert(title: "Error", message: "Error Downloading Images from Flickr!")
                return
            }
            if images.count == 0 {
                self.showErrorAlert(title: "No Image", message: "No Images for the current location!")
            }
            print(images)
            self.location.loaded = true
        }
       
    }
    
    // Refreshes the images with new images from Flickr
    @IBAction func onNewCollectionClick(sender: UIButton!) {
        if let images = fetchedResultsController.fetchedObjects {
            for image in images {
                context.delete(image)
            }
        }
        downloadLocationImages()
    }

}

extension AlbumViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let image = fetchedResultsController.object(at: indexPath)
        if let data = image.data {
            cell.activityIndicator.stopAnimating()
            // set image to image based on data..
            let img = UIImage(data: data as Data)
            cell.imageView.image = img
        } else {
            cell.activityIndicator.startAnimating()
            cell.imageView.image = nil
            imageManager.downloadImage(forImage: image)
        }
        return cell
    }
    
}

extension AlbumViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

extension AlbumViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths  = [IndexPath]()
        updatedIndexPaths  = [IndexPath]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            insertedIndexPaths.append(newIndexPath!)
        case .update:
            updatedIndexPaths.append(indexPath!)
        case .delete:
            deletedIndexPaths.append(indexPath!)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItems(at: [indexPath])
            }
            for indexPath in self.deletedIndexPaths {
                self.collectionView.deleteItems(at: [indexPath])
            }
            for indexPath in self.updatedIndexPaths {
                self.collectionView.reloadItems(at: [indexPath])
            }
        }, completion: nil)
    }
        
}

extension AlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let image = fetchedResultsController.object(at: indexPath)
        context.delete(image)
        
    }
}
