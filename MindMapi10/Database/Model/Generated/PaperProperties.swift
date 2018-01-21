//
//  Paper+CoreDataProperties.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 14.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//
//

import Foundation
import CoreData


extension Paper {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Paper> {
        return NSFetchRequest<Paper>(entityName: "Paper")
    }

    @NSManaged public var abstract: String?
    @NSManaged public var added_date: NSDate?
    @NSManaged public var author: String?
    @NSManaged public var id: Int32
    @NSManaged public var importance_id: Int16
    @NSManaged public var is_active: Int16
    @NSManaged public var is_reference: Int16
    @NSManaged public var mind_map_id: Int32
    @NSManaged public var paper_cord_x: Float
    @NSManaged public var paper_cord_y: Float
    @NSManaged public var pdf_url: String?
    @NSManaged public var storage_type_id: Int16
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var importance: Importance?
    @NSManaged public var mind_map: Mind_map?
    @NSManaged public var note: NSSet?
    @NSManaged public var paper: NSSet?
    @NSManaged public var storage: Storage?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for note
extension Paper {

    @objc(addNoteObject:)
    @NSManaged public func addToNote(_ value: Note)

    @objc(removeNoteObject:)
    @NSManaged public func removeFromNote(_ value: Note)

    @objc(addNote:)
    @NSManaged public func addToNote(_ values: NSSet)

    @objc(removeNote:)
    @NSManaged public func removeFromNote(_ values: NSSet)

}

// MARK: Generated accessors for paper
extension Paper {

    @objc(addPaperObject:)
    @NSManaged public func addToPaper(_ value: Paper_mapping)

    @objc(removePaperObject:)
    @NSManaged public func removeFromPaper(_ value: Paper_mapping)

    @objc(addPaper:)
    @NSManaged public func addToPaper(_ values: NSSet)

    @objc(removePaper:)
    @NSManaged public func removeFromPaper(_ values: NSSet)

}
