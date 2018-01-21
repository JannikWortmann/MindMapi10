//
//  Mind_map+CoreDataClass.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 14.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//
//

import Foundation
import CoreData

public class Mind_map: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creation_date = NSDate()
    }
}
