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
        
        let doc = iOSDocument(title: "HCI Research Paper Mind Map", author: "i10 Dev Team", abstract: "Ein Text der alles zusammenfasst. Sodass man einen kleinen Eindruck von der Referenz bekommt und sie vielleicht hinzufügt oder auch noch einmal lesen möchte", url: "", pdfUrl: "")
        
        let ctr = iOSPDFNavigationController(rootDocument: doc, references: [doc, doc])
        
        present(ctr, animated: true, completion: nil)
    }

    @IBAction func createMindMapAction(_ sender: Any) {
        
        let view = iOSPopupCreateNewMap { (title, topic) in
            DispatchQueue.main.async(execute: {() -> Void in
                self.dismiss(animated: true, completion: nil)
                self.navigate(title, topic)
            })
        }
        
        present(view, animated: true, completion: nil)
    }
    
    @IBAction func btnImportAction(_ sender: Any) {
        //TODO
    }
    
    
    private func navigate(_ title:String,_ topic:String){
        let nodeViewController = self.storyboard?.instantiateViewController(withIdentifier: "NodeViewController") as! NodeViewController
        
        nodeViewController.shouldCreateMindMap = true
        nodeViewController.mainNodeTitle = title
        nodeViewController.mainNodeTopic = topic
        
        navigationController?.pushViewController(nodeViewController, animated: true)
    }
}

