//
//  NodeFrame.swift
//  MindMapi10
//
//  Created by Sabir Alizada on 1/17/18.
//  Copyright © 2018 Halt. All rights reserved.
//

import Foundation
import UIKit

public class Node{
    let height: CGFloat
    let width: CGFloat
    let center: CGPoint
    let title: String
    
    init(width: CGFloat, height: CGFloat, center:CGPoint, title: String){
        self.height = height
        self.width = width
        self.center = center
        self.title = title
    }
}
