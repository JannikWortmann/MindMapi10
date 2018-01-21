//
//  Reference_mapping+CoreDataProperties.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 19.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//
//

import Foundation
import CoreData


extension Reference_mapping {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reference_mapping> {
        return NSFetchRequest<Reference_mapping>(entityName: "Reference_mapping")
    }

    @NSManaged public var paper_id: Int32
    @NSManaged public var reference_id: Int32
    @NSManaged public var paper_reference: Paper?

}
