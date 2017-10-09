//
//  Image+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Maria  on 10/9/17.
//  Copyright © 2017 Maria . All rights reserved.
//
//

import Foundation
import CoreData

@objc(Image)
public class Image: NSManagedObject {

    convenience init(url: URL, location: Location, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Image", in: context) {
            self.init(entity: ent, insertInto: context)
            self.url = url
            self.location = location
        } else {
            fatalError("No Entity")
        }
    }
}
