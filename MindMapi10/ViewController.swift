//
//  ViewController.swift
//  MindMapi10
//
//  Created by Sabir Alizada on 1/12/18.
//  Copyright © 2018 Halt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, iOSSelectedReferencesDelegate {
    func iOSDidSelectReferences(_ pDocuments: [DocumentModel]) {
        print("did")
    }
    

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
        
        let doc = DocumentModel(id: 10, title: "HCI Research Paper Mind Map", author: "i10 Dev Team", abstract: "Ein Text der alles zusammenfasst. Sodass man einen kleinen Eindruck von der Referenz bekommt und sie vielleicht hinzufügt oder auch noch einmal lesen möchte", url: "", pdf_url: "http://delivery.acm.org/10.1145/210000/202671/P073.pdf?ip=134.61.73.87&id=202671&acc=ACTIVE%20SERVICE&key=575DA4752A380C0F%2E4D4702B0C3E38B35%2E4D4702B0C3E38B35%2E4D4702B0C3E38B35&__acm__=1517055507_94546811b916c4363db4e2729fd0bdbd", references: [])
        
        let doc2 = DocumentModel(id: 11, title: "HCI Research Paper Mind Map123", author: "ST der gott", abstract: "Ein Text der alles zusammenfasst. Sodass man einen kleinen Eindruck von der Referenz bekommt und sie vielleicht hinzufügt oder auch noch einmal lesen möchte", url: "", pdf_url: "http://delivery.acm.org/10.1145/210000/202671/P073.pdf?ip=134.61.73.87&id=202671&acc=ACTIVE%20SERVICE&key=575DA4752A380C0F%2E4D4702B0C3E38B35%2E4D4702B0C3E38B35%2E4D4702B0C3E38B35&__acm__=1517055507_94546811b916c4363db4e2729fd0bdbd", references: [doc])
        
        let ctr = iOSPDFNavigationController(rootDocument: doc2, delegate: self)
        //ctr.cDelegate = self
        
//        present(ctr, animated: true, completion: nil)
    }

    @IBAction func createMindMapAction(_ sender: Any) {
        
        let view = iOSPopupCreateNewMap { (title, topic) in
            DispatchQueue.main.async(execute: {() -> Void in
                self.dismiss(animated: true, completion: nil)
                self.navigate(title, topic)
            })
        }
        view.modalPresentationStyle = .overCurrentContext
        
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

