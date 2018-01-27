//
//  iOSPDFPreviewController.swift
//  MindMapi10
//
//  Created by Jannik Wortmann on 24.01.18.
//  Copyright © 2018 Halt. All rights reserved.
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
        setupUI()
    }
    
//------------------------------------------------------------------------------------------
    //MARK: UI Functions
    func setupUI() {
        self.navigationItem.rightBarButtonItem = self.isAddButtonHidden ? nil : self.cAddReferenceButton
        
        let URLString = self.cRootDocument.pdf_url.replacingOccurrences(of: "&#URLTOKEN#", with: "&key=575DA4752A380C0F%2E4D4702B0C3E38B35%2E4D4702B0C3E38B35%2E4D4702B0C3E38B35&__acm__=1517090405_85b61cf85207217f12fed53ef1a08112")
        let req = URLRequest(url: URL(string: URLString)!)
        
        self.cWebView.load(req)
    }
}

//------------------------------------------------------------------------------------------
    //MARK: Button Actions
extension iOSPDFPreviewController {
    @objc func cHandleAddReference() {
        self.delegate?.iOSDidAddedReference(self.cRootDocument)
        
        self.navigationController?.popViewController(animated: true)
    }
}
