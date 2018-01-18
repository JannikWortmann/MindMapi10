//
//  GlobalDefines.swift
//  iOSPopupDialogs
//
//  Created by Jannik Wortmann on 12.01.18.
//  Copyright © 2018 Payload1337. All rights reserved.
//

import Foundation
import UIKit

struct Fonts {
    static let gLabelFontBig = UIFont(name: "HelveticaNeue-Light", size: 40)
    static let gLabelFontMedium = UIFont(name: "HelveticaNeue-Light", size: 30)
    
    static let gButtonFontBig = UIFont(name: "HelveticaNeue-Light", size: 30)
}

struct Document {
    private var _title: String
    private var _author: String
    private var _url: String
    private var _pdf_url: String
    private var _references_link: String
    private var _paper_cord_x: Float
    private var _paper_cord_y: Float
}

