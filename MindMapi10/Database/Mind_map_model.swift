//
//  Mind_map_model.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 08.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//

import Foundation
import CoreData

public class Mind_map_model {
    
    private var _id: Int32
    private var _title: String
    private var _topic: String
    private var _map_cord_x: Float
    private var _map_cord_y: Float
    private var _creation_date: String
    
    private var _papers: [Document]
    private var _mappings: [Paper_mapping]
    
    init() {
        _id = 0
        _title = ""
        _topic = ""
        _map_cord_x = 0
        _map_cord_y = 0
        _papers = []
        _mappings = []
        _creation_date = ""
    }
    
    init(id: Int32, title: String, topic: String, map_cord_x: Float, map_cord_y: Float, papers: [Document], mappings: [Paper_mapping], creation_date: String) {
        _id = id
        _title = title
        _topic = topic
        _map_cord_x = map_cord_x
        _map_cord_y = map_cord_y
        _papers = papers
        _mappings = mappings
        _creation_date = creation_date
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
    
    var topic: String {
        get {
            return _topic
        }
        set {
            _topic = newValue
        }
    }
    
    var map_cord_x: Float {
        get {
            return _map_cord_x
        }
        set {
            _map_cord_x = newValue
        }
    }
    
    var map_cord_y: Float {
        get {
            return _map_cord_y
        }
        set {
            _map_cord_y = newValue
        }
    }
    
    var papers: [Document] {
        get {
            return _papers
        }
        set {
            _papers = newValue
        }
    }
    
    var mappings: [Paper_mapping] {
        get {
            return _mappings
        }
        set {
            _mappings = newValue
        }
    }
    
    var creation_date: String {
        get {
            return _creation_date
        }
        set {
            _creation_date = newValue
        }
    }
}

