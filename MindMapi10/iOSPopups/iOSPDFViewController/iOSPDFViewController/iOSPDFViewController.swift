//
//  iOSPDFViewController.swift
//  ResearchPaperMindMap
//
//  Created by Jannik Wortmann on 16.01.18.
//  Copyright © 2018 Payload1337. All rights reserved.
//

import UIKit
import WebKit

class iOSPDFViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//------------------------------------------------------------------------------------------
    //MARK: UI Variables
    @IBOutlet weak var cWebView: WKWebView!
    @IBOutlet weak var cReferencesCollectionView: UICollectionView!
    @IBOutlet weak var cHorizontalLine: UIView!
    
    
    @IBOutlet weak var cWebViewBottomConstraint: NSLayoutConstraint!
    //------------------------------------------------------------------------------------------
    //MARK: Variables
    public var cReferences: [iOSDocument]
    
    public var cRootDocument: iOSDocument
    
//------------------------------------------------------------------------------------------
    //MARK: Initalizers
    init(rootDocument: iOSDocument, documentReferences: [iOSDocument]?) {
        self.cRootDocument = rootDocument
        self.cReferences = documentReferences ?? []
        
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.title = rootDocument.title
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//------------------------------------------------------------------------------------------
    //MARK: UIViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if self.cReferences.isEmpty {
            //show full size pdf
            self.cHorizontalLine.isHidden = true
            self.cReferencesCollectionView.isHidden = true
            
            self.cWebViewBottomConstraint.isActive = false
            self.cWebView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            
        }
        else {
            //initial page
            self.navigationItem.leftBarButtonItem =
                UIBarButtonItem(title: "╳", style: .plain, target: self, action: #selector(handleCancel))
        }
    }
    
//------------------------------------------------------------------------------------------
    //MARK: Setup CollectionView
    func setupUI() {
        //----------------------------------------------------------------------------------
        // cReferenceCollectionView
        //----------------------------------------------------------------------------------
        cReferencesCollectionView.register(UINib(nibName: "iOSReferencesCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        cReferencesCollectionView.dataSource = self
        cReferencesCollectionView.delegate = self
        
        
        let req = URLRequest(url: URL(string: "http://delivery.acm.org/10.1145/210000/202671/P073.pdf?ip=134.61.99.92&id=202671&acc=ACTIVE%20SERVICE&key=575DA4752A380C0F%2E4D4702B0C3E38B35%2E4D4702B0C3E38B35%2E4D4702B0C3E38B35&__acm__=1516657232_9c879ec49982b8acca76d2d8324e90de")!)
        
        cWebView.load(req)
        
    }
}

//MARK: Delegates and DataSource CollectionView
extension iOSPDFViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cReferences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! iOSReferencesCell
        let lDocument = self.cReferences[indexPath.row]
        
        cell.titleLabel.text = lDocument.title
        cell.authorLabel.text = lDocument.author
        cell.abstractLabel.text = lDocument.abstract
        cell.referenceAddButton.addTarget(self, action: #selector(handleSelectReference), for: .touchUpInside)
        cell.referenceReadButton.addTarget(self, action: #selector(handleReadReference), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 160)
    }
}

//CollectionViewCell Button Actions
extension iOSPDFViewController {
    @objc func handleSelectReference() {
        
    }
    
    @objc func handleReadReference() {
        let indexPaths = cReferencesCollectionView.indexPathsForVisibleItems
        if indexPaths.count == 1 {
            let lDoc = self.cReferences[indexPaths[0].row]
            
            let nextVC = iOSPDFViewController(rootDocument: lDoc, documentReferences: nil)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
