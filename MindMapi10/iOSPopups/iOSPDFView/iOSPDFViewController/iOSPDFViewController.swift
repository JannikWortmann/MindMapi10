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
    func iOSDidAddedReference(_ pDocument: DocumentModel)
}

protocol iOSSelectedReferencesDelegate {
    func iOSDidSelectReferences(_ pDocuments: [DocumentModel])
}

//------------------------------------------------------------------------------------------
//MARK: iOSPDFCellStruct
struct iOSDocumentCellModel {
    var isSelected: Bool
    var document: DocumentModel
}

//------------------------------------------------------------------------------------------
//MARK: iOSPDFViewController
class iOSPDFViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//------------------------------------------------------------------------------------------
    //MARK: XIB Variables
    @IBOutlet weak var cWebView: WKWebView!
    @IBOutlet weak var cReferencesCollectionView: UICollectionView!
    @IBOutlet weak var cHorizontalLine: UIView!
    @IBOutlet weak var collectionVIewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cWebViewBottomConstraint: NSLayoutConstraint!
    
//------------------------------------------------------------------------------------------
    //MARK: UI Variables
    lazy var cScrollIndicatorLeft: UIButton = {
        let img = UIButton(type: .system)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.setImage(UIImage(imageLiteralResourceName: "iconArrowLeft"), for: .normal)
        //img.image = UIImage(imageLiteralResourceName: "iconArrowLeft")
        img.layer.borderColor = UIColor.black.cgColor
        img.contentMode = .scaleAspectFit
        //img.layer.borderWidth = 1
        //img.layer.cornerRadius = 15
        img.clipsToBounds = true
        img.addTarget(self, action: #selector(cScrollLeft), for: .touchUpInside)
        return img
    }()
    
    @objc func cScrollLeft() {
        let lNewPos = cReferencesCollectionView.contentOffset.x - cReferencesCollectionView.frame.width
        if lNewPos >= 0 {
            self.cReferencesCollectionView.contentOffset.x = lNewPos
        }
    }
    
    lazy var cScrollIndicatorRight: UIButton = {
        let img = UIButton(type: .system)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.setImage(UIImage(imageLiteralResourceName: "iconArrowRight"), for: .normal)
        img.contentMode = .scaleAspectFit
        img.layer.borderColor = UIColor.black.cgColor
        //img.layer.borderWidth = 1
        //img.layer.cornerRadius = 15
        img.clipsToBounds = true
        img.addTarget(self, action: #selector(cScrollRight), for: .touchUpInside)
        return img
    }()
    
    
    @objc func cScrollRight() {
        let lNewPos = cReferencesCollectionView.contentOffset.x + cReferencesCollectionView.frame.width
        if lNewPos <= cReferencesCollectionView.contentSize.width {
            self.cReferencesCollectionView.contentOffset.x = lNewPos
        }
    }
    
    //--------------------------------------------------------------------------------------
    // cNoReferencesLabel
    //--------------------------------------------------------------------------------------
    var cNoReferencesLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "No References!"
        lbl.font = Fonts.gLabelFontMedium
        lbl.isHidden = true
        return lbl
    }()
    
//------------------------------------------------------------------------------------------
    //MARK: Variables
    public var cReferences: [iOSDocumentCellModel] = []
    
    public var cRootDocument: DocumentModel
    
    public var cDelegate: iOSSelectedReferencesDelegate?
    
//------------------------------------------------------------------------------------------
    //MARK: Initalizers
    init(rootDocument: DocumentModel, delegate: iOSSelectedReferencesDelegate?) {
        cRootDocument = rootDocument
        cDelegate = delegate
        
        for lDoc in rootDocument.references {
            let lStruct = iOSDocumentCellModel(isSelected: false, document: lDoc)
            cReferences.append(lStruct)
        }
        
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.title = rootDocument.title
    }
    
    init(rootDocument: DocumentModel) {
        cRootDocument = rootDocument
        
        for lDoc in rootDocument.references {
            let lStruct = iOSDocumentCellModel(isSelected: false, document: lDoc)
            cReferences.append(lStruct)
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
        
        //Add Cancel Button
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: UIImage(imageLiteralResourceName: "iconCancel"), style: .plain, target: self, action: #selector(handleCancel))
        
        if cReferences.isEmpty {
            //Display label with no references!
            self.cScrollIndicatorLeft.isHidden = true
            self.cScrollIndicatorRight.isHidden = true
            self.cNoReferencesLabel.isHidden = false
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
        cReferencesCollectionView.bounces = true
        
        //----------------------------------------------------------------------------------
        // cScrollIndicatorLeft
        //----------------------------------------------------------------------------------
        self.view.addSubview(cScrollIndicatorLeft)
        cScrollIndicatorLeft.centerYAnchor.constraint(equalTo: cReferencesCollectionView.centerYAnchor).isActive = true
        cScrollIndicatorLeft.leftAnchor.constraint(equalTo: cReferencesCollectionView.leftAnchor, constant: 4).isActive = true
        cScrollIndicatorLeft.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cScrollIndicatorLeft.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        //----------------------------------------------------------------------------------
        // cScrollIndicatorRight
        //----------------------------------------------------------------------------------
        self.view.addSubview(cScrollIndicatorRight)
        cScrollIndicatorRight.centerYAnchor.constraint(equalTo: cReferencesCollectionView.centerYAnchor).isActive = true
        cScrollIndicatorRight.rightAnchor.constraint(equalTo: cReferencesCollectionView.rightAnchor, constant: -4).isActive = true
        cScrollIndicatorRight.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cScrollIndicatorRight.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        //----------------------------------------------------------------------------------
        // cWebView
        //----------------------------------------------------------------------------------
        let URLString = self.cRootDocument.pdf_url.replacingOccurrences(of: "&#URLTOKEN#", with: "")
        let req = URLRequest(url: URL(string: URLString)!)
        cWebView.load(req)
        
        //----------------------------------------------------------------------------------
        // cNoReferencesLabel
        //----------------------------------------------------------------------------------
        self.cReferencesCollectionView.addSubview(self.cNoReferencesLabel)
        
        cNoReferencesLabel.centerXAnchor.constraint(equalTo: self.cReferencesCollectionView.centerXAnchor).isActive = true
        cNoReferencesLabel.centerYAnchor.constraint(equalTo: cReferencesCollectionView.centerYAnchor).isActive = true
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
        
        //Setup Buttons
        let lAddImage = lStruct.isSelected ? UIImage(imageLiteralResourceName: "iconCheck") : UIImage(imageLiteralResourceName: "iconPlus")
        cell.referenceAddButton.setImage(lAddImage, for: .normal)
        
        cell.referenceAddButton.tag = indexPath.row
        cell.referenceAddButton.addTarget(self, action: #selector(handleSelectReference), for: .touchUpInside)

        cell.referenceReadButton.isEnabled = !lDocument.pdf_url.isEmpty
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
        
        //add checkmark for feedback
        let advTimeGif = UIImage.gif(name: "checkmark")
        let imageView2 = UIImageView(image: advTimeGif)
        imageView2.frame = CGRect(x: self.view.frame.size.width - 90.0, y: 50.0, width: 100, height: 100.0)
        view.addSubview(imageView2)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            imageView2.removeFromSuperview()
        })
        
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
        let lSelectedDocs = lSelectedStructs.map { (structCell) -> DocumentModel in
            return structCell.document
        }
        self.cDelegate?.iOSDidSelectReferences(lSelectedDocs)
        
        self.dismiss(animated: true, completion: nil)
    }
}

//------------------------------------------------------------------------------------------
//MARK: iOSAddNewReference Delegate
extension iOSPDFViewController: iOSAddedReferenceDelegate {
    func iOSDidAddedReference(_ pDocument: DocumentModel) {
        //search the document inside the array and set it so ,isSelected,=true
        if let lIndex = self.cReferences.index(where: {$0.document.id == pDocument.id}) {
            self.cReferences[lIndex].isSelected = true
        }
        
        //add checkmark for feedback
        let advTimeGif = UIImage.gif(name: "checkmark")
        let imageView2 = UIImageView(image: advTimeGif)
        imageView2.frame = CGRect(x: self.view.frame.size.width - 90.0, y: 50.0, width: 100, height: 100.0)
        view.addSubview(imageView2)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            imageView2.removeFromSuperview()
        })
        
        self.cReferencesCollectionView.reloadData()
    }
}
