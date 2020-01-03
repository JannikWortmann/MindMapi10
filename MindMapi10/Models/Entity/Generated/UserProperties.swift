//
//  User+CoreDataProperties.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 14.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: Int32
    @NSManaged public var institution: String?
    @NSManaged public var is_active: Int16
    @NSManaged public var join_date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var surname: String?
    @NSManaged public var mind_map: NSSet?
    @NSManaged public var paper: NSSet?

}

// MARK: Generated accessors for mind_map
extension User {

    @objc(addMind_mapObject:)
    @NSManaged public func addToMind_map(_ value: Mind_map)

    @objc(removeMind_mapObject:)
    @NSManaged public func removeFromMind_map(_ value: Mind_map)

    @objc(addMind_map:)
    @NSManaged public func addToMind_map(_ values: NSSet)

    @objc(removeMind_map:)
    @NSManaged public func removeFromMind_map(_ values: NSSet)

}

// MARK: Generated accessors for paper
extension User {

    @objc(addPaperObject:)
    @NSManaged public func addToPaper(_ value: Paper)

    @objc(removePaperObject:)
    @NSManaged public func removeFromPaper(_ value: Paper)

    @objc(addPaper:)
    @NSManaged public func addToPaper(_ values: NSSet)

    @objc(removePaper:)
    @NSManaged public func removeFromPaper(_ values: NSSet)

}
