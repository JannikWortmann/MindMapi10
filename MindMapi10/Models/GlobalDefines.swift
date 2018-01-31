//
//  GlobalDefines.swift
//  iOSPopupDialogs
//
//  Created by Jannik Wortmann on 12.01.18.
//  Copyright © 2018 Payload1337. All rights reserved.
//

import Foundation
import UIKit

//------------------------------------------------------------------------------------------
    //MARK: Font Defines
    struct Fonts {
        static let gLabelFontBig = UIFont(name: "HelveticaNeue-Light", size: 40)
        static let gLabelFontMedium = UIFont(name: "HelveticaNeue-Light", size: 30)
        static let gButtonFontBig = UIFont(name: "HelveticaNeue-Light", size: 30)
    }
//------------------------------------------------------------------------------------------
    //MARK: Internal Structs
    struct iOSDocument: Equatable {
        let id: Int
        let title: String
        let author: String
        let abstract: String
        let url: String
        let pdfUrl: String
    }

    func == (left: iOSDocument, right: iOSDocument) -> Bool {
            return left.title == right.title && left.author == right.author && left.abstract == right.abstract && left.url == right.url && left.pdfUrl == right.pdfUrl
    }

struct acmDocument {
    let title: String
    let author: String
    let abstract: String
    let url: String
    let pdfUrl: String
    
    func getReferences() -> acmDocument? {
        return nil
    }
}
