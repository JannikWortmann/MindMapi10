//
//  iOSPDFViewController.swift
//  ResearchPaperMindMap
//
//  Created by Jannik Wortmann on 16.01.18.
//  Copyright © 2018 Payload1337. All rights reserved.
//

import UIKit
import WebKit

//------------------------------------------------------------------------------------------
    //MARK: Protocols
protocol iOSAddedReferenceDelegate {
    func iOSDidAddedReference(_ pDocument: iOSDocument)
}

protocol iOSSelectedReferencesDelegate {
    func iOSDidSelectReferences(_ pDocuments: [iOSDocument])
}

//------------------------------------------------------------------------------------------
    //MARK: iOSPDFCellStruct
struct iOSDocumentCellModel {
    var isSelected: Bool
    var document: iOSDocument
}

//------------------------------------------------------------------------------------------
    //MARK: iOSPDFViewController
class iOSPDFViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//------------------------------------------------------------------------------------------
    //MARK: XIB Variables
    @IBOutlet weak var cWebView: WKWebView!
    @IBOutlet weak var cReferencesCollectionView: UICollectionView!
    @IBOutlet weak var cHorizontalLine: UIView!
    
    @IBOutlet weak var cWebViewBottomConstraint: NSLayoutConstraint!
    
//------------------------------------------------------------------------------------------
    //MARK: UI Variables
    var cScrollIndicatorLeft: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(imageLiteralResourceName: "iconArrowLeft")
        img.backgroundColor = UIColor.gray
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        return img
    }()
    
    var cScrollIndicatorRight: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(imageLiteralResourceName: "iconArrowRight")
        img.backgroundColor = UIColor.gray
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        return img
    }()
    
//------------------------------------------------------------------------------------------
    //MARK: Variables
    public var cReferences: [iOSDocumentCellModel] = []
    
    public var cRootDocument: iOSDocument
    
    public var cDelegate: iOSSelectedReferencesDelegate?
    
//------------------------------------------------------------------------------------------
    //MARK: Initalizers
    init(rootDocument: iOSDocument, documentReferences: [iOSDocument], delegate: iOSSelectedReferencesDelegate?) {
        cRootDocument = rootDocument
        cDelegate = delegate
        
        for document in documentReferences {
            let lModel = iOSDocumentCellModel(isSelected: false, document: document)
            cReferences.append(lModel)
        }
        
        
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.title = rootDocument.title
    }
    
    init(rootDocument: iOSDocument, documentReferences: [iOSDocument]) {
        cRootDocument = rootDocument
        
        for document in documentReferences {
            let lModel = iOSDocumentCellModel(isSelected: false, document: document)
            cReferences.append(lModel)
        }
        
        
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
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        }
        else {
            //initial page
            self.navigationItem.leftBarButtonItem =
                UIBarButtonItem(image: UIImage(imageLiteralResourceName: "iconCancel"), style: .plain, target: self, action: #selector(handleCancel))
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
        
        self.view.addSubview(cScrollIndicatorLeft)
        cScrollIndicatorLeft.centerYAnchor.constraint(equalTo: cReferencesCollectionView.centerYAnchor).isActive = true
        cScrollIndicatorLeft.leftAnchor.constraint(equalTo: cReferencesCollectionView.leftAnchor, constant: 4).isActive = true
        cScrollIndicatorLeft.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cScrollIndicatorLeft.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(cScrollIndicatorRight)
        cScrollIndicatorRight.centerYAnchor.constraint(equalTo: cReferencesCollectionView.centerYAnchor).isActive = true
        cScrollIndicatorRight.rightAnchor.constraint(equalTo: cReferencesCollectionView.rightAnchor, constant: -4).isActive = true
        cScrollIndicatorRight.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cScrollIndicatorRight.widthAnchor.constraint(equalToConstant: 40).isActive = true
        //----------------------------------------------------------------------------------
        // cWebView
        //----------------------------------------------------------------------------------
        let req = URLRequest(url: URL(string: self.cRootDocument.pdfUrl)!)
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
        let lDocument = self.cReferences[indexPath.row].document
        let lStruct = self.cReferences[indexPath.row]
        
        //Setup Labels
        cell.document = lDocument
        cell.titleLabel.text = lDocument.title
        cell.authorLabel.text = lDocument.author
        cell.abstractLabel.text = lDocument.abstract
        
        //Setup Buttons
        let lAddImage = lStruct.isSelected ? UIImage(imageLiteralResourceName: "iconCheck") : UIImage(imageLiteralResourceName: "iconPlus")
        cell.referenceAddButton.setImage(lAddImage, for: .normal)
        
        cell.referenceAddButton.tag = indexPath.row
        cell.referenceAddButton.addTarget(self, action: #selector(handleSelectReference), for: .touchUpInside)
        cell.referenceReadButton.tag = indexPath.row
        cell.referenceReadButton.addTarget(self, action: #selector(handleReadReference), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 160)
    }
}

//CollectionViewCell Button Actions
extension iOSPDFViewController {
    @objc func handleSelectReference(_ sender: UIButton) {
        self.cReferences[sender.tag].isSelected = !self.cReferences[sender.tag].isSelected
        
        let lDocument = self.cReferences[sender.tag]
        
        let lImage = lDocument.isSelected ? UIImage(imageLiteralResourceName: "iconCheck") : UIImage(imageLiteralResourceName: "iconPlus")
        
        sender.setImage(lImage, for: .normal)
    }
    
    @objc func handleReadReference(_ sender: UIButton) {
        let lDoc = self.cReferences[sender.tag].document
        
        let nextVC = iOSPDFPreviewController(pRootDocument: lDoc)
        nextVC.delegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func handleCancel() {
        //filter the selected documents
        let lSelectedStructs = self.cReferences.filter { (doc) -> Bool in
            return doc.isSelected
        }
        //get the documents from the struct
        let lSelectedDocs = lSelectedStructs.map { (structCell) -> iOSDocument in
            return structCell.document
        }
        self.cDelegate?.iOSDidSelectReferences(lSelectedDocs)
        
        self.dismiss(animated: true, completion: nil)
    }
}

//------------------------------------------------------------------------------------------
//MARK: iOSAddNewReference Delegate
extension iOSPDFViewController: iOSAddedReferenceDelegate {
    func iOSDidAddedReference(_ pDocument: iOSDocument) {
        //search the document inside the array and set it so ,isSelected,=true
        if let lIndex = self.cReferences.index(where: {$0.document == pDocument}) {
            self.cReferences[lIndex].isSelected = true
        }
        self.cReferencesCollectionView.reloadData()
    }
}
