//
//  Note+CoreDataProperties.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 14.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var added_date: NSDate?
    @NSManaged public var content: String?
    @NSManaged public var id: Int32
    @NSManaged public var paper_id: Int32
    @NSManaged public var paper: Paper?

}
