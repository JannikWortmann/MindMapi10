//
//  SearchViewController.swift
//  MindMapi10
//
//  Created by Orkhan Alizada on 23.01.18.
//  Copyright © 2018 Halt. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: UIGraphDelegate?
    
    var papers = [Document]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting delegates
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Registering cell to use it later
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "searchCell")
        tableView.tableFooterView = UIView()
        
        self.title = "Seach paper"
    }

    func callPreviewPDFController(doc: DocumentModel){
        let pdfPreViewController = iOSPDFPreviewController(pRootDocument: doc)
        pdfPreViewController.isAddButtonHidden = true
        _ = self.navigationController?.pushViewController(pdfPreViewController, animated: true)
    }
}

// UITableViewDataSource methods
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Using custom UITableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        cell.titleLabel.text = papers[indexPath.row].title
        cell.authorsLabel.text = papers[indexPath.row].author
        cell.abstractLabel.text = papers[indexPath.row].abstract
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return papers.count
    }
    
    // Setting the height of cells responsive
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    // Allowing swipe menu for cells
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Adding "Add" button on swipe to the left
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addAction = UITableViewRowAction(style: .normal, title: "Add") { action, index in
            self.delegate?.drawNode(doc: self.papers[indexPath.row])
            
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        return [addAction]
    }
}

// UITableViewDelegate methods
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPaper = papers[indexPath.row]
        
        let doc = DocumentModel()
        doc.pdf_url = selectedPaper.pdf_url
        doc.title = selectedPaper.title
        
        // Call PDF Preview Controller on select
        self.callPreviewPDFController(doc: doc)
    }
}

// UISearchBarDelegate methods
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let search = Engine.shared.getData(from: searchBar.text!)
        
        // Remove all previous papers before filling the array
        papers.removeAll()
        search.forEach { (paper) in
            let doc = Document()
            doc.abstract = paper.abstract
            doc.title = paper.title
            doc.url = paper.url
            doc.pdf_url = paper.pdf_url
            doc.author = paper.author
            
            papers.append(doc)
        }
        
        // Reload UITableView to show new data
        tableView.reloadData()
    }
}
