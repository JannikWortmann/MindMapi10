//
//  iOSPDFViewController.swift
//  MindMapi10
//
//  Created by Jannik Wortmann on 16.01.18.
//  Copyright © 2018 Jannik Wortmann. All rights reserved.
//

import UIKit
import WebKit

//------------------------------------------------------------------------------------------
    //MARK: Protocols

//Notifies, that a reference in preview was selected
protocol iOSAddedReferenceDelegate {
    func iOSDidAddedReference(_ pDocument: DocumentModel)
}

//Notifies, that the given documents was selected
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
    
//------------------------------------------------------------------------------------------
    //MARK: UI Variables
    lazy var cScrollIndicatorLeft: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(imageLiteralResourceName: "iconArrowLeft"), for: .normal)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.contentMode = .scaleAspectFit
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(cScrollLeft), for: .touchUpInside)
        return btn
    }()
    
    @objc func cScrollLeft() {
        let lNewPos = cReferencesCollectionView.contentOffset.x - cReferencesCollectionView.frame.width
        if lNewPos >= 0 {
            self.cReferencesCollectionView.contentOffset.x = lNewPos
        }
    }
    
    lazy var cScrollIndicatorRight: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(imageLiteralResourceName: "iconArrowRight"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.layer.borderColor = UIColor.black.cgColor
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(cScrollRight), for: .touchUpInside)
        return btn
    }()
    
    @objc func cScrollRight() {
        let lNewPos = cReferencesCollectionView.contentOffset.x + cReferencesCollectionView.frame.width
        if lNewPos < cReferencesCollectionView.contentSize.width {
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
        
        //Initalize the references struct. Default: NOT selected
        for lDoc in rootDocument.references {
            let lStruct = iOSDocumentCellModel(isSelected: false, document: lDoc)
            cReferences.append(lStruct)
        }
        
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.title = rootDocument.title
    }
    
    init(rootDocument: DocumentModel) {
        cRootDocument = rootDocument
        
        //Initalize the references struct. Default: NOT selected
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
        
        //save the cell index
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
        
        //get document from index of the button. Saved earlier in "cellForRowAt"
        let lDocument = self.cReferences[sender.tag]
        
        let lImage = lDocument.isSelected ? UIImage(imageLiteralResourceName: "iconCheck") : UIImage(imageLiteralResourceName: "iconPlus")
        
        showCheckMark()
        
        //set Button Image
        sender.setImage(lImage, for: .normal)
    }
    
    @objc func handleReadReference(_ sender: UIButton) {
        let lDoc = self.cReferences[sender.tag].document
        
        //create a new PDFPreview
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
        
        showCheckMark()
        
        //load the new checkmarks of the items
        self.cReferencesCollectionView.reloadData()
    }
}

//------------------------------------------------------------------------------------------
//MARK: UI Checkmark Function
extension iOSPDFViewController {
    func showCheckMark() {
        let lAdvTimeGif = UIImage.gif(name: "checkmark")
        let lImageView = UIImageView(image: lAdvTimeGif)
        lImageView.frame = CGRect(x: self.view.frame.size.width - 90.0, y: 50.0, width: 100, height: 100.0)
        view.addSubview(lImageView)
        //show image for 4 seconds then remove it
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            lImageView.removeFromSuperview()
        })
    }
}
