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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

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
        
    }
}
