//
//  NodeViewController+Converter.swift
//  MindMapi10
//
//  Created by Sabir Alizada on 1/27/18.
//  Copyright © 2018 Halt. All rights reserved.
//

import Foundation

extension NodeViewController {
    func converDocumentToDocumentModel(docs: [Document])->[DocumentModel]{
        var documentModels = [DocumentModel]()
        
        docs.forEach{ doc in
            let docModel = DocumentModel()
            
            docModel.abstract = doc.abstract
            docModel.author = doc.author
            docModel.id = doc.id
            docModel.pdf_url = doc.pdf_url
            docModel.title = doc.title
            docModel.url = doc.url
            
            documentModels.append(docModel)
        }
        
        return documentModels
    }
}
