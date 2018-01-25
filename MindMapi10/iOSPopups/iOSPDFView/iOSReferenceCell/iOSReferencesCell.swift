//
//  iOSReferencesCell.swift
//  ResearchPaperMindMap
//
//  Created by Jannik Wortmann on 16.01.18.
//  Copyright © 2018 Payload1337. All rights reserved.
//

import UIKit

class iOSReferencesCell: UICollectionViewCell {
    var document: iOSDocument!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var referenceAddButton: UIButton!
    @IBOutlet weak var referenceReadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
