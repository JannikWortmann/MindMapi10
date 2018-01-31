//
//  Storage+CoreDataProperties.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 14.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//
//

import Foundation
import CoreData


extension Storage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Storage> {
        return NSFetchRequest<Storage>(entityName: "Storage")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var paper: NSSet?

}

// MARK: Generated accessors for paper
extension Storage {

    @objc(addPaperObject:)
    @NSManaged public func addToPaper(_ value: Paper)

    @objc(removePaperObject:)
    @NSManaged public func removeFromPaper(_ value: Paper)

    @objc(addPaper:)
    @NSManaged public func addToPaper(_ values: NSSet)

    @objc(removePaper:)
    @NSManaged public func removeFromPaper(_ values: NSSet)

}
