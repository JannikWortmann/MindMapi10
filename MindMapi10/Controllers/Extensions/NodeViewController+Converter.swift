//
//  NodeViewController+Converter.swift
//  MindMapi10
//
//  Created by Sabir Alizada on 1/27/18.
//  Copyright © 2018 Halt. All rights reserved.
//

import Foundation

//Mark: - Convertion extension.
extension NodeViewController {
    //Mark: - Convert Document class to the DocumentModel class.
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
    
    //Mark: - Convert DocumentModel class to the Document class.
    func converDocumentModelToDocument(docs: [DocumentModel])->[Document]{
        var documents = [Document]()
        
        docs.forEach{ docModel in
            let doc = Document()
            
            doc.abstract = docModel.abstract
            doc.author = docModel.author
            doc.id = docModel.id
            doc.pdf_url = docModel.pdf_url
            doc.title = docModel.title
            doc.url = docModel.url
            
            documents.append(doc)
        }
        
        return documents
    }
}
