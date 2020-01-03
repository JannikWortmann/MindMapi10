//
//  NodeViewController+Animation.swift
//  MindMapi10
//
//  Created by Sabir Alizada on 1/26/18.
//  Copyright © 2018 Halt. All rights reserved.
//

import Foundation
import UIKit

//Mark: - Animation extension.
extension NodeViewController {
    //Mark: - Bring note sub view with animation.
    func animateIn(){
        self.view.addSubview(notesSubView)
        notesSubView.center = self.view.center
        
        notesSubView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        notesSubView.alpha = 0
        
        UIView.animate(withDuration: 0.3){
            self.visualEffect.effect = self.effect
            self.visualEffect.isUserInteractionEnabled = true
            self.notesSubView.alpha = 1
            self.notesSubView.transform = CGAffineTransform.identity
        }
    }
    
    //Mark: - Remove note sub view with animation.
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.notesSubView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.notesSubView.alpha = 0
            
            self.visualEffect.effect = nil
            self.visualEffect.isUserInteractionEnabled = false
        }) { (success:Bool) in
            self.notesSubView.removeFromSuperview()
        }
    }
}
