//
//  Document.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 08.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//

import Foundation
import CoreData

class Document {
    
    private var _id: Int32
    private var _title: String
    private var _author: String
    private var _abstract: String
    private var _url: String
    private var _pdf_url: String
    private var _references: [Document]
    
    init() {
        _id = 0
        _title = ""
        _author = ""
        _abstract = ""
        _url = ""
        _pdf_url = ""
        _references = [Document]()
    }
    
    init(id: Int32, title: String, author: String, abstract: String, url: String, pdf_url: String, references: [Document]) {
        _id = id
        _title = title
        _author = author
        _abstract = abstract
        _url = url
        _pdf_url = pdf_url
        _references = references
    }
    
    var id: Int32 {
        get {
            return _id
        }
        set {
            _id = newValue
        }
    }
    
    var title: String {
        get {
            return _title
        }
        set {
            _title = newValue
        }
    }
    
    var author: String {
        get {
            return _author
        }
        set {
            _author = newValue
        }
    }
    
    var abstract: String {
        get {
            return _abstract
        }
        set {
            _abstract = newValue
        }
    }
    
    
    var url: String {
        get {
            return _url
        }
        set {
            _url = newValue
        }
    }
    
    var pdf_url: String {
        get {
            return _pdf_url
        }
        set {
            _pdf_url = newValue
        }
    }
    
    var references: [Document] {
        get {
            return _references
        }
        set {
            _references = newValue
        }
    }
}
