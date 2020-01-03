//
//  iOSPDFPreviewController.swift
//  MindMapi10
//
//  Created by Jannik Wortmann on 24.01.18.
//  Copyright © 2018 Jannik Wortmann. All rights reserved.
//

import UIKit
import WebKit

class iOSPDFPreviewController: UIViewController {
//------------------------------------------------------------------------------------------
    //MARK: XIB Variables
    @IBOutlet weak var cWebView: WKWebView!
    
//------------------------------------------------------------------------------------------
    //MARK: UI Variables
    lazy var cAddReferenceButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(cHandleAddReference))
        return btn
    }()
    
//------------------------------------------------------------------------------------------
    //MARK: Callbacks
    var delegate: iOSAddedReferenceDelegate?
    
//------------------------------------------------------------------------------------------
    //MARK: Variables
    
    var cRootDocument: DocumentModel
    
    var isAddButtonHidden: Bool = false
    
//------------------------------------------------------------------------------------------
    //MARK: Initializer
    init(pRootDocument: DocumentModel) {
        self.cRootDocument = pRootDocument
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//------------------------------------------------------------------------------------------
    //MARK: ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
//------------------------------------------------------------------------------------------
    //MARK: UI Functions
    func setup() {
        //Optional set the Add Button
        self.navigationItem.rightBarButtonItem = self.isAddButtonHidden ? nil : self.cAddReferenceButton
        
        //Load the PDF from ACM and display it
        let url = cRootDocument.pdf_url.replacingOccurrences(of: "&#URLTOKEN#", with: "")
        let req = URLRequest(url: URL(string: url)!)
        self.cWebView.load(req)
    }
}


extension iOSPDFPreviewController {
//------------------------------------------------------------------------------------------
    //MARK: Button Actions
    @objc func cHandleAddReference() {
        //Notify, that reference was selected
        self.delegate?.iOSDidAddedReference(self.cRootDocument)
        
        //go to previous view
        self.navigationController?.popViewController(animated: true)
    }
}
