//
//  UIGraphDelegate.swift
//  MindMapi10
//
//  Created by Sabir Alizada on 1/17/18.
//  Copyright © 2018 Halt. All rights reserved.
//

import Foundation

// Informs when ready for drawing the node.
protocol UIGraphDelegate: class {
    func drawNode(doc:Document)
}
