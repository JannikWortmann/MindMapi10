//
//  Document.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 08.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//

import Foundation

public class Document {
    
    private var _id: Int32
    private var _title: String
    private var _author: String
    private var _abstract: String
    private var _url: String
    private var _pdf_url: String
    private var _importance_id: Int16
    private var _is_reference: Int16
    private var _paper_cord_x: Float
    private var _paper_cord_y: Float
    
    private var _references: [Document]
    private var _notes: [Note]
    
    init() {
        _id = 0
        _title = ""
        _author = ""
        _abstract = ""
        _url = ""
        _pdf_url = ""
        _importance_id = 1
        _is_reference = 0
        _paper_cord_x = 0
        _paper_cord_y = 0
        _references = [Document]()
        _notes = [Note]()
        
    }
    
    init(id: Int32, title: String, author: String, abstract: String, url: String, pdf_url: String, importance_id: Int16, is_reference: Int16,paper_cord_x: Float, paper_cord_y: Float, references: [Document], notes: [Note]) {
        _id = id
        _title = title
        _author = author
        _abstract = abstract
        _url = url
        _pdf_url = pdf_url
        _importance_id = importance_id
        _is_reference = is_reference
        _paper_cord_x = paper_cord_x
        _paper_cord_y = paper_cord_y
        _references = references
        _notes = notes
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
    
    var importance_id: Int16 {
        get {
            return _importance_id
        }
        set {
            _importance_id = newValue
        }
    }
    
    var is_reference: Int16 {
        get {
            return _is_reference
        }
        set {
            _is_reference = newValue
        }
    }
    
    var paper_cord_x: Float {
        get {
            return _paper_cord_x
        }
        set {
            _paper_cord_x = newValue
        }
    }
    
    var paper_cord_y: Float {
        get {
            return _paper_cord_y
        }
        set {
            _paper_cord_y = newValue
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
    
    var notes: [Note] {
        get {
            return _notes
        }
        set {
            _notes = newValue
        }
    }
}
