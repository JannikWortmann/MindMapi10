//
//  Mind_map+CoreDataProperties.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 14.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//
//

import Foundation
import CoreData


extension Mind_map {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mind_map> {
        return NSFetchRequest<Mind_map>(entityName: "Mind_map")
    }

    @NSManaged public var creation_date: NSDate?
    @NSManaged public var id: Int32
    @NSManaged public var map_cord_x: Float
    @NSManaged public var map_cord_y: Float
    @NSManaged public var title: String?
    @NSManaged public var topic: String?
    @NSManaged public var user_id: Int32
    @NSManaged public var paper: Paper?
    @NSManaged public var user: User?

}
