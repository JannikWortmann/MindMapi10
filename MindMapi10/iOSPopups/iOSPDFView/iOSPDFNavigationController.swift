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
    public var cRootDocument: DocumentModel?
    
    //Callback Delegate
    public var cDelegate: iOSSelectedReferencesDelegate?

//------------------------------------------------------------------------------------------
    //MARK: ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//------------------------------------------------------------------------------------------
    //MARK: Initializer
    init(rootDocument: DocumentModel, delegate: iOSSelectedReferencesDelegate?) {
        self.cRootDocument = rootDocument
        self.cDelegate = delegate
        
        let lVC = iOSPDFViewController(rootDocument: rootDocument, delegate: delegate)
        super.init(rootViewController: lVC)
    }
    
    init(rootDocument: DocumentModel) {
        self.cRootDocument = rootDocument
        
        let lVC = iOSPDFViewController(rootDocument: rootDocument)
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

}
