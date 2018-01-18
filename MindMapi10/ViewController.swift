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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let doc = iOSDocument(title: "Test Title", author: "Test Author", abstract: "Test Abstract cdihcoeiwupvnfupvnfewiuvfipewnvujnvpefunvefpwnvuwvfuipewvjefpnwvjfepvifbwcjfencjipnkdcneipncukpcdjupibfekjcdbvfpmebvpfeijkvfiedpnjbfipfjepvebcdilkszopci", url: "", pdfUrl: "")
        
        let ref = iOSDocument(title: "The Reference Title", author: "Test Author", abstract: "Test Abstract cdihcoeicddfunvefpwnvuwvfuipewvjefpnwvjfepvifbwcjfencjipnkdcneipncukpcdjupibfekjcdbvfpmebvpfeijkvfiedpnjbfipfjepvebcdilkszopci", url: "", pdfUrl: "")
        
        let refs = [ref, ref]
        
        let x = iOSPDFNavigationController(rootDocument: doc, references: refs)
        
        present(x, animated: true, completion: nil)
    }
    

}

