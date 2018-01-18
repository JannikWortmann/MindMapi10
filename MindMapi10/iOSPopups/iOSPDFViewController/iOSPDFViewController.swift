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
    @IBOutlet weak var cWebView: WKWebView!
    @IBOutlet weak var cReferencesCollectionView: UICollectionView!
    
    
//------------------------------------------------------------------------------------------
    //MARK: UIViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //https://dl.acm.org/ft_gateway.cfm?id=1358904&ftid=507513&dwn=1&CFID=1024972837&CFTOKEN=93669979
        let url = URL(string: "http://delivery.acm.org/10.1145/1360000/1358904/p3633-borchers.pdf?ip=134.61.81.59&id=1358904&acc=ACTIVE%20SERVICE&key=575DA4752A380C0F%2E4D4702B0C3E38B35%2E4D4702B0C3E38B35%2E4D4702B0C3E38B35&CFID=1024972837&CFTOKEN=93669979&__acm__=1516269910_afe1ab8634189f5f0e80b5570ca8bbec")!
        let request = URLRequest(url: url)
        cWebView.load(request)
        
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
    }
    
}

//MARK: Delegates and DataSource CollectionView
extension iOSPDFViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 160)
    }
}
