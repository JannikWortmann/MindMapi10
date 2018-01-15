//
//  Structs.swift
//  MindMapi10
//
//  Created by Orkhan Alizada on 15.01.18.
//  Copyright © 2018 Halt. All rights reserved.
//

import Foundation

struct Object {
    var titles: [String: String]
    
    init(titles: [String: String]) {
        self.titles = titles
    }
}

struct TitlesObject {
    var title: String
    var author: String
    var link: String
    var abstract: String
    var pdfURL: String
}
