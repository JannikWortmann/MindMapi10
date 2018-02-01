//
//  MapCell.swift
//  MindMapi10
//
//  Created by Jona Hebaj on 21.01.18.
//  Copyright © 2018 Halt. All rights reserved.
//

import UIKit

class MapCell: UITableViewCell {
    
    
    @IBOutlet weak var lblTitleMap: UILabel!
    @IBOutlet weak var lblTopicMap: UILabel!
    @IBOutlet weak var lblDateMap: UILabel!
    @IBOutlet weak var lblPapersMap: UILabel!
    @IBOutlet weak var imgMindMap: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //function called after each update of a mind map in the table view of the mind maps
    func updateUI(mind_map_model: Mind_map_model) {
        lblTitleMap.text = mind_map_model.title
        lblTopicMap.text = mind_map_model.topic
        lblDateMap.text = "Created: " + mind_map_model.creation_date
        let cnt = mind_map_model.papers.count
        
        if cnt == 1 {
            lblPapersMap.text = String(cnt) + " paper"
        } else {
            lblPapersMap.text = String(cnt) + " papers"
        }
        
        //displays the screenshot of a mind map if it exists in the folder
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        do {
            let screenPath = documentDirectoryPath.appendingPathComponent("Screenshots").appendingPathComponent("mind_map_\(mind_map_model.id).png")
            
            if FileManager.default.fileExists(atPath: screenPath.relativePath) {
                //set path of image
                let url = URL(string: screenPath.absoluteString)
                let data = try Data(contentsOf: url!)
                imgMindMap.image = UIImage(data: data)
            }
        } catch {
            print("Error while fetchin the screenshot for mind map : \(error)")
        }
    }
}
