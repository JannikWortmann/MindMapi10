//
//  ViewController.swift
//  MindMapi10
//
//  Created by Sabir Alizada on 1/12/18.
//  Copyright © 2018 Halt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createMindMapAction(_ sender: Any) {
        // Animate and create popup window
        // Navigate to the NodeViewController
        
        let nodeViewController = self.storyboard?.instantiateViewController(withIdentifier: "NodeViewController") as! NodeViewController
        nodeViewController.shouldCreateMindMap = true
        self.navigationController?.pushViewController(nodeViewController, animated: true)
    }
    
    
    /*func animateIn(){
        self.view.addSubview(notesSubView)
        notesSubView.center = self.view.center
        
        notesSubView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        notesSubView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.visualEffect.effect = self.effect
            self.visualEffect.isUserInteractionEnabled = true
            self.notesSubView.alpha = 1
            self.notesSubView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.notesSubView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.notesSubView.alpha = 0
            
            self.visualEffect.effect = nil
            self.visualEffect.isUserInteractionEnabled = false
        }) { (success:Bool) in
            self.notesSubView.removeFromSuperview()
        }
    }*/
}

