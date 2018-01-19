//
//  iOSPDFNavigationController.swift
//  MindMapi10
//
//  Created by Jannik Wortmann on 18.01.18.
//  Copyright © 2018 Halt. All rights reserved.
//

import UIKit

class iOSPDFNavigationController: UINavigationController {
//------------------------------------------------------------------------------------------
    //MARK: Public vars
    
    //Document Property
    public var cRootDocument: iOSDocument?
    
    //rootDocuments References
    public var cRootDocumentReferences: [iOSDocument]?
    

//------------------------------------------------------------------------------------------
    //MARK: ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//------------------------------------------------------------------------------------------
    //MARK: Initializer
    init(rootDocument: iOSDocument, references: [iOSDocument]?) {
        self.cRootDocument = rootDocument
        self.cRootDocumentReferences = references
        
        
        let lVC = iOSPDFViewController(rootDocument: rootDocument, documentReferences: references)
        super.init(rootViewController: lVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
//------------------------------------------------------------------------------------------
    //MARK: Class Functions
    func setupUI() {
        
    }
    
    @objc func handleCancelClick() {
        self.dismiss(animated: true, completion: nil)
    }

}
