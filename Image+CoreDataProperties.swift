//
//  Image+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Maria  on 10/9/17.
//  Copyright © 2017 Maria . All rights reserved.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var url: URL?
    @NSManaged public var data: NSData?
    @NSManaged public var location: Location?

}
