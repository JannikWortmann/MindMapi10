//
//  iOSReferencesCell.swift
//  MindMapi10
//
//  Created by Jannik Wortmann on 16.01.18.
//  Copyright © 2018 Jannik Wortmann. All rights reserved.
//

import UIKit

class iOSReferencesCell: UICollectionViewCell {
    var document: DocumentModel!
    
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
