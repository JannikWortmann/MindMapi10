//
//  DBImportExport.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 14.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//

import Foundation
import CoreData

public class DBImportExport {
    
    var controller: NSFetchedResultsController<Mind_map>!
    var mind_map_mappings = [[String: Any]]()
    let db = DBTransactions()
    
    public func importMindMap(mind_map_title: String) -> Mind_map_model {
        var return_model = Mind_map_model()
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return return_model }
        let filePath = documentDirectoryPath.appendingPathComponent("Export-Import").appendingPathComponent(mind_map_title)
        do{
            let textRead = try Data(contentsOf: filePath)
            let json = try? JSONSerialization.jsonObject(with: textRead, options: [])
            print("Read text from import file")
            print(filePath)
            print(textRead)
            
            let new_map_id = db.getNewID(forEntity: "Mind_map")
            var new_paper_id = db.getNewID(forEntity: "Paper")
            var new_note_id = db.getNewID(forEntity: "Note")
            
            var papers: [String: Any]?
            var mappings: [String: Any]?
            var paperIDChangeDict = [Int32:Int32]()
            
            if let dictionary = json as? [String: Any] {
                if let nested_dictionary = dictionary["mind map"] as? [String: Any]{
                    
                    for (key, value) in nested_dictionary {
                        if key == "papers" {
                            papers = value as? [String : Any]
                        } else if key == "mappings" {
                            mappings = value as? [String : Any]
                        }
                    }
                    
                    var references_array = [Int32: Any]()
                    
                    for (k, _) in papers! {
                        if let nested_papers = papers![k] as? [String: Any]{
                            let paper = Paper(context: context)
                            paper.id = new_paper_id
                            paper.is_active = 1
                            paper.mind_map_id = new_map_id
                            paper.importance_id = 1
                            
                            paperIDChangeDict.updateValue(new_paper_id, forKey: Int32(k)!)
                            var notes: [String: Any]?
                            var references: [String: Any]?
                            var temp_references = [[Int32]]()
                            for(key, value) in nested_papers {
                                if key == "author" {
                                    paper.author = value as? String
                                } else if key == "abstract" {
                                    paper.abstract = value as? String
                                } else if key == "pdf_url" {
                                    paper.pdf_url = value as? String
                                } else if key == "title" {
                                    paper.title = value as? String
                                } else if key == "url" {
                                    paper.url = value as? String
                                } else if key == "storage_type_id" {
                                    paper.storage_type_id = value as! Int16
                                } else if key == "is_reference" {
                                    paper.is_reference = value as! Int16
                                } else if key == "paper_cord_x" {
                                    paper.paper_cord_x = value as! Float
                                } else if key == "paper_cord_y" {
                                    paper.paper_cord_y = value as! Float
                                } else if key == "notes" {
                                    notes = value as? [String: Any]
                                } else if key == "references" {
                                    references = value as? [String: Any]
                                }
                            }
                            //Add the notes
                            for (k1, _) in notes! {
                                if let nested_notes = notes![k1] as? [String: Any]{
                                    let note = Note(context: context)
                                    note.id = new_note_id
                                    note.paper_id = new_paper_id
                                    new_note_id += 1
                                    
                                    for(key1, value1) in nested_notes {
                                        if key1 == "content" {
                                            note.content = value1 as? String
                                        }
                                    }
                                    ad.saveContext()
                                }
                            }
                            
                            //Add references pair [x,y] to the temp_references array
                            for (k2, _) in references! {
                                if let nested_references = references![k2] as? [String: Any]{
                                    var paper_id: Int32!
                                    var reference_id: Int32!
                                    for(key2, value2) in nested_references {
                                        if key2 == "paper_id" {
                                            paper_id = value2 as! Int32
                                        } else if key2 == "reference_id" {
                                            reference_id = value2 as! Int32
                                        }
                                    }
                                    temp_references.append([paper_id, reference_id])
                                }
                            }
                            
                            ad.saveContext()
                            references_array.updateValue(temp_references, forKey: new_paper_id)
                            new_paper_id += 1
                        }
                    }
                    //Add references for each paper using the references_array created previously
                    for (_, val) in references_array {
                        
                        for el in val as! [[Int32]] {
                            let reference = Reference_mapping(context: context)
                            reference.paper_id = paperIDChangeDict[el[0]]!
                            reference.reference_id = paperIDChangeDict[el[1]]!
                            
                            ad.saveContext()
                        }
                    }
                    
                    //Add paper mappings
                    for (k, _) in mappings! {
                        if let nested_mappings = mappings![k] as? [String: Any]{
                            let mapping = Paper_mapping(context: context)
                            mapping.mind_map_id = new_map_id
                            
                            var paper_id: Int32!
                            var connect_id: Int32!
                            var is_root_level: Int16!
                            
                            for(key2, value2) in nested_mappings {
                                if key2 == "is_root_level" {
                                    mapping.is_root_level = value2 as! Int16
                                    is_root_level = mapping.is_root_level
                                } else if key2 == "paper_id" {
                                    paper_id = value2 as! Int32
                                } else if key2 == "connected_to_id" {
                                    connect_id = value2 as! Int32
                                } else if key2 == "relation_text" {
                                    mapping.relation_text = value2 as? String
                                }
                            }
                            
                            //root level connection means that the central topic is connected to a paper (first level)
                            if is_root_level == 1 {
                                mapping.paper_id = new_map_id
                                if paperIDChangeDict[connect_id] != nil {
                                    mapping.connected_to_id = paperIDChangeDict[connect_id]!
                                }
                            } else if is_root_level == 0 {
                                if paperIDChangeDict[paper_id] != nil {
                                    mapping.paper_id = paperIDChangeDict[paper_id]!
                                }
                                if paperIDChangeDict[connect_id] != nil {
                                    mapping.connected_to_id = paperIDChangeDict[connect_id]!
                                }
                            }
                            
                            ad.saveContext()
                            
                        }
                    }
                    
                    let map = Mind_map(context: context)
                    map.id = new_map_id
                    map.user_id = 1
                    
                    for (key, value) in nested_dictionary {
                        if key == "id" {
                            map.id = value as! Int32
                        } else if key == "title" {
                            map.title = value as? String
                        } else if key == "topic" {
                            map.topic = value as? String
                        } else if key == "map_cord_x" {
                            map.map_cord_x = value as! Float
                        } else if key == "map_cord_y" {
                            map.map_cord_y = value as! Float
                        }
                    }
                    ad.saveContext()
                    return_model = db.getMindMap(mind_map_id: new_map_id)
                    return return_model
                }
            }
        }catch {
            print(error)
        }
        
        return return_model
    }
    
    public func exportMindMap(mind_map_id: Int32) {
        //FETCH DATA
        mind_map_mappings = [[String: Any]]()
        let fetch_mind_map = NSFetchRequest<NSFetchRequestResult>(entityName: "Mind_map")
        fetch_mind_map.returnsObjectsAsFaults = false
        fetch_mind_map.predicate = NSPredicate(format: "id = %d", mind_map_id)
        
        //let formatter = DateFormatter()
        //formatter.dateFormat = "dd-MM-yyyy"
        do {
            //fetch the mind map
            let mind_map = try context.fetch(fetch_mind_map) as! [Mind_map] //NSManagedObject
            var mind_map_dictionary = [String: Any]()
            
            //fetch papers that are related to this mind map and are not deleted (namely is_active is 1)
            let fetch_papers = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper")
            fetch_papers.predicate = NSPredicate(format: "mind_map_id = %d AND is_active = 1", mind_map[0].value(forKey: "id") as! Int)
            let papers = try context.fetch(fetch_papers) as! [Paper]
            
            var papers_dictionary = [String: Any]()
            for paper in papers {
                
                //fetch notes corresponding to each paper
                let fetch_notes = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
                fetch_notes.predicate = NSPredicate(format: "paper_id = %d", paper.value(forKey: "id") as! Int)
                let notes = try context.fetch(fetch_notes) as! [Note]
                
                var notes_dictionary = [String: Any]()
                for note in notes {
                    let note_dict = createNoteDictionary(note_object: note)
                    let note_id = note.value(forKey: "id") as! Int32
                    notes_dictionary.updateValue(note_dict, forKey: "\(note_id)")
                }
                
                //fetch references corresponding to each paper
                let fetch_references = NSFetchRequest<NSFetchRequestResult>(entityName: "Reference_mapping")
                fetch_references.predicate = NSPredicate(format: "paper_id = %d", paper.value(forKey: "id") as! Int)
                let references = try context.fetch(fetch_references) as! [Reference_mapping]
                
                var references_dictionary = [String: Any]()
                var cnt_ref = 1
                for reference in references {
                    let reference_dict = createReferenceMappingDictionary(reference_object: reference)
                    references_dictionary.updateValue(reference_dict, forKey: "\(cnt_ref)")
                    cnt_ref += cnt_ref + 1
                }
                
                let paper_dict = createPaperDictionary(paper_object: paper, notes_dictionary: notes_dictionary, references_dictionary: references_dictionary)
                let paper_id = paper.value(forKey: "id") as! Int
                papers_dictionary.updateValue(paper_dict, forKey: "\(paper_id)")
            }
            
            //fetch mappings that are related to this mind map
            getPaperMappings(mind_map_id: mind_map[0].value(forKey: "id") as! Int32)
            var cnt = 1
            var mappings_dictionary = [String: Any]()
            for mapping in mind_map_mappings {
                mappings_dictionary.updateValue(mapping, forKey: "\(cnt)")
                cnt += 1
            }
            
            let mind_map_dict = createMindMapDictionary(map_object: mind_map[0], papers_dictionary: papers_dictionary, mappings_dictionary: mappings_dictionary)
            mind_map_dictionary.updateValue(mind_map_dict, forKey: "mind map")
            
            //CREATE JSON OBJECT WITH THE FETCHED DATA
            //print(mind_map_dictionary)
            let mind_map_title = mind_map[0].value(forKey: "title") as! String
            saveMindMapToJSONFile(mind_map: mind_map_dictionary as NSDictionary, mind_map_title: mind_map_title)
            
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    
    //helping function to export a mind map -> gets the papers hierachical relations/mappings
    private func getPaperMappings(mind_map_id: Int32) {
        let fetch_mapping = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper_mapping")
        fetch_mapping.predicate = NSPredicate(format: "mind_map_id = %d AND is_root_level = 1 AND paper_id = %d", mind_map_id, mind_map_id)
        do{
            let mappings = try context.fetch(fetch_mapping)
            
            for map in mappings as! [NSManagedObject] {
                let temp_map_dictionary = createMappingDictionary(map_object: map)
                mind_map_mappings.append(temp_map_dictionary)
                
                getPaperMappings(connected: map.value(forKey: "connected_to_id") as! Int32, mind_map_id: mind_map_id)
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    private func getPaperMappings(connected: Int32, mind_map_id: Int32) {
        let fetch_mapping = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper_mapping")
        fetch_mapping.predicate = NSPredicate(format: "mind_map_id = %d AND paper_id = %d AND is_root_level = 0", mind_map_id, connected)
        do{
            let mappings = try context.fetch(fetch_mapping) as! [NSManagedObject]
            
            for map in mappings  {
                let temp_map_dictionary = createMappingDictionary(map_object: map)
                mind_map_mappings.append(temp_map_dictionary)
                
                getPaperMappings(connected: map.value(forKey: "connected_to_id") as! Int32, mind_map_id: mind_map_id)
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    //helping function to export a mind map
    func createMappingDictionary(map_object: NSManagedObject) -> [String: Any] {
        let temp_map_dictionary = [
            "mind_map_id": map_object.value(forKey: "mind_map_id") as! Int32,
            "is_root_level": map_object.value(forKey: "is_root_level") as! Int16,
            "paper_id": map_object.value(forKey: "paper_id") as! Int32,
            "connected_to_id": map_object.value(forKey: "connected_to_id") as! Int32,
            "relation_text": map_object.value(forKey: "relation_text") as! String
            ] as [String : Any]
        return temp_map_dictionary
    }
    
    func createMindMapDictionary(map_object: NSManagedObject, papers_dictionary: [String: Any], mappings_dictionary: [String: Any]) -> [String: Any] {
        let mind_map_dict = [
            "title": map_object.value(forKey: "title") as! String,
            "topic": map_object.value(forKey: "topic") as! String,
            "map_cord_x":map_object.value(forKey: "map_cord_x") as! Float,
            "map_cord_y": map_object.value(forKey: "map_cord_y") as! Float,
            "papers": papers_dictionary,
            "mappings": mappings_dictionary
            ] as [String : Any]
        
        return mind_map_dict
    }
    
    func createPaperDictionary(paper_object: NSManagedObject, notes_dictionary: [String: Any], references_dictionary: [String: Any]) -> [String: Any] {
        let paper_dictionary = [
            "title": paper_object.value(forKey: "title") as! String,
            "abstract": paper_object.value(forKey: "abstract") as! String,
            "author": paper_object.value(forKey: "author") as! String,
            "storage_type_id": paper_object.value(forKey: "storage_type_id") as! Int16,
            "url": paper_object.value(forKey: "url") as! String,
            "pdf_url": paper_object.value(forKey: "pdf_url") as! String,
            "paper_cord_x": paper_object.value(forKey: "paper_cord_x") as! Float,
            "paper_cord_y": paper_object.value(forKey: "paper_cord_y") as! Float,
            "is_reference": paper_object.value(forKey: "is_reference") as! Int16,
            "notes": notes_dictionary,
            "references": references_dictionary
            ] as [String : Any]
        return paper_dictionary
    }
    
    func createNoteDictionary(note_object: NSManagedObject) -> [String: Any] {
        let note_dictionary = [
            "content": note_object.value(forKey: "content") as! String,
            //convert the date to string, since error is thrown otherwise if Date is used
            //"added_date": formatter.string(from: note.value(forKey: "added_date") as! Date)
            ] as [String : Any]
        return note_dictionary
    }
    
    func createReferenceMappingDictionary(reference_object: NSManagedObject) -> [String: Any] {
        let ref_dictionary = [
            "paper_id": reference_object.value(forKey: "paper_id") as! Int32,
            "reference_id": reference_object.value(forKey: "reference_id") as! Int32
            ] as [String: Any]
        
        return ref_dictionary
    }
    
    
    //helping function to export a mind map -> saves an NSDictionary to a JSON file
    func saveMindMapToJSONFile(mind_map: NSDictionary, mind_map_title: String){
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let exportPath = documentDirectoryPath.appendingPathComponent("Export-Import")
        
        do{
            if !directoryExistsAtPath(exportPath.relativePath) {
                try FileManager.default.createDirectory(atPath: exportPath.relativePath, withIntermediateDirectories: true, attributes: nil)
            }
            let filePath = exportPath.appendingPathComponent(mind_map_title + " export.json")
        
            if FileManager.default.fileExists(atPath: filePath.relativePath) {
                try FileManager.default.removeItem(at: filePath)
            }
            if let jsonMind = try? JSONSerialization.data(withJSONObject: mind_map, options:[.prettyPrinted]){
                print(filePath)
                print(mind_map)
                try jsonMind.write(to: filePath)
            }
        }catch {
            print("Error while creating and writing JSON to file : \(error)")
        }
            
        
    }
    
    public func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}

