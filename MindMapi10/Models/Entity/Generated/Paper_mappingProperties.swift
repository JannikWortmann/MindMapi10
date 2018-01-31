//
//  Paper_mapping+CoreDataProperties.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 14.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//
//

import Foundation
import CoreData


extension Paper_mapping {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Paper_mapping> {
        return NSFetchRequest<Paper_mapping>(entityName: "Paper_mapping")
    }

    @NSManaged public var connected_to_id: Int32
    @NSManaged public var is_root_level: Int16
    @NSManaged public var mind_map_id: Int32
    @NSManaged public var paper_id: Int32
    @NSManaged public var relation_text: String?
    @NSManaged public var paper: NSSet?

}

// MARK: Generated accessors for paper
extension Paper_mapping {

    @objc(addPaperObject:)
    @NSManaged public func addToPaper(_ value: Paper)

    @objc(removePaperObject:)
    @NSManaged public func removeFromPaper(_ value: Paper)

    @objc(addPaper:)
    @NSManaged public func addToPaper(_ values: NSSet)

    @objc(removePaper:)
    @NSManaged public func removeFromPaper(_ values: NSSet)

}
