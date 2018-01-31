//
//  NodeViewController+Math.swift
//  MindMapi10
//
//  Created by Sabir Alizada on 1/26/18.
//  Copyright © 2018 Halt. All rights reserved.
//

import Foundation
import UIKit

//Mark: - Math operation extension.
extension NodeViewController {
    //Mark: - Calculate angel between arrow and perpendicular line.
    func calculateArrowAngle(_ point1: CGPoint,_ point2: CGPoint)->CGFloat{
        let hipotenuz = self.distance(point1, point2)
        let cater = self.distance(point1, CGPoint(x:point2.x, y:point1.y))
        let angle = acos(Double(cater/hipotenuz)) * 180 / .pi
        
        return CGFloat(angle)
    }
    
    //Mark: - Distance between to points.
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    //Mark: - Calculate intersection of 2 lines.
    func calculateIntersectionX(_ point1: CGPoint,_ point2: CGPoint,_ b_y: CGFloat)-> CGFloat{
        let a = (point2.y - point1.y)/(point2.x - point2.x)
        let b = point1.y - (a * point1.x)
        
        let x = (b_y - b)/a
        
        return x
    }
}
