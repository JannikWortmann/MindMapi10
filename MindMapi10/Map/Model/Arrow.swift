//
//  Arrow.swift
//  MindMapi10
//
//  Created by Sabir Alizada on 1/15/18.
//  Copyright © 2018 Halt. All rights reserved.
//

import Foundation
import UIKit

public class Arrow{
    let shape: CAShapeLayer
    let label: UILabel
    
    init(_ shape: CAShapeLayer, _ label:UILabel){
        self.shape = shape
        self.label = label
    }
}
