//
//  Location+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Maria  on 10/6/17.
//  Copyright © 2017 Maria . All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double

}
