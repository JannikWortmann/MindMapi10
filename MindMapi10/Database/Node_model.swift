//
//  Node.swift
//  MindMapi10
//
//  Created by Jona Hebaj on 27.01.18.
//  Copyright © 2018 Halt. All rights reserved.
//
import Foundation
import CoreData

class Node_model {
    
    private var _importance_id: Int16
    private var _paper_cord_x: Float
    private var _paper_cord_y: Float
    private var _document: Document
    private var _notes: [Note]
    
    init() {
        _importance_id = 1
        _paper_cord_x = 0
        _paper_cord_y = 0
        _document = Document()
        _notes = [Note]()
        
    }
    
    init(importance_id: Int16, paper_cord_x: Float, paper_cord_y: Float, document: Document, notes: [Note]) {
        _importance_id = importance_id
        _paper_cord_x = paper_cord_x
        _paper_cord_y = paper_cord_y
        _document = document
        _notes = notes
    }
    
    var importance_id: Int16 {
        get {
            return _importance_id
        }
        set {
            _importance_id = newValue
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
    
    var document: Document {
        get {
            return _document
        }
        set {
            _document = newValue
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
