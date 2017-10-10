//
//  ImageManager.swift
//  VirtualTourist
//
//  Created by Maria  on 10/10/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ImageManager {
   
    let flickrAPI = FlickrAPI()
    
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

    //Fetches the Flickr Images and converts the corresponding JSON to Image NSManagedObject
    func getFlickrImages(forLocation location: Location, completionHandler: @escaping ([Image]?, Error?) -> Void) {
        flickrAPI.searchByLocation(location: location) { (photoJSONs, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            guard let jsons = photoJSONs  else {
                DispatchQueue.main.async {
                    completionHandler(nil, nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                var images = [Image]()
                for json in jsons {
                    if let urlString = json["url_m"], let url = URL(string: urlString as! String) {
                        let image = Image(url: url, location: location, context: self.context)
                        images.append(image)
                    }
                }
                completionHandler(images, nil)
            }
        }
    }
    
    
    //Code based on Udacity Lectures. Downloads the image data corresponding to the image.
    func downloadImage(forImage image: Image) {
        // Get the URL for the image
        let url = image.url!
        // create a queue from scratch
        let downloadQueue = DispatchQueue(label: "download", attributes: [])
        
        // call dispatch async to send a closure to the downloads queue
        downloadQueue.async { () -> Void in
            
            // download Data
            let imgData = try? Data(contentsOf: url)
            
            // display it
            DispatchQueue.main.async(execute: { () -> Void in
                image.data = imgData as NSData?
                self.stack.save()
            })
        }
    }
}
