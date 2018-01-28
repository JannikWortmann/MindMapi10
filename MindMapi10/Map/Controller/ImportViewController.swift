//
//  ImportViewController.swift
//  MindMapi10
//
//  Created by Jona Hebaj on 21.01.18.
//  Copyright © 2018 Halt. All rights reserved.
//

import UIKit

protocol MindMapListDelegate {
    func onMindMapAdd(new_map: Mind_map_model)
}


class ImportViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: MindMapListDelegate?
    
    let db = DBImportExport()
    var fileURLs = [URL]()
    
    override func viewDidLoad() {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Export-Import") else { return }
        
        do {
            if !directoryExistsAtPath(documentDirectoryPath.relativePath) {
                try FileManager.default.createDirectory(atPath: documentDirectoryPath.relativePath, withIntermediateDirectories: true, attributes: nil)
            }
            
            let fileURLsTemp = try FileManager.default.contentsOfDirectory(at: documentDirectoryPath, includingPropertiesForKeys: nil)
            
            for file in fileURLsTemp {
                if file.lastPathComponent.hasSuffix(".json") {
                    fileURLs.append(file)
                }
            }
            
        } catch {
            let error = error as NSError
            print("\(error)")
        }        
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fileURLs.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImportCell", for: indexPath as IndexPath) as! ImportCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.lblFileName.text = self.fileURLs[indexPath.item].lastPathComponent
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let map = db.importMindMap(mind_map_title: self.fileURLs[indexPath.item].lastPathComponent)
        
        let nodeViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        delegate?.onMindMapAdd(new_map: map)
        navigationController?.pushViewController(nodeViewController, animated: true)
        
    }
    
    public func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
}
