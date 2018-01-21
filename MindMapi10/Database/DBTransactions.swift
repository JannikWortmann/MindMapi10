//
//  File.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 14.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//

import Foundation
import CoreData

public class DBTransactions {
    
    var mind_map_mappings = [Paper_mapping]()
    
    // INSERT INTO DATABASE A MIND MAP
    func insertMindMap(model: Mind_map_model) -> Int32 {
        let new_mind_map_id = getNewID(forEntity: "Mind_map")
        let new_mind_map = Mind_map(context: context)
        new_mind_map.id = new_mind_map_id
        new_mind_map.title = model.title
        new_mind_map.topic = model.topic
        new_mind_map.user_id = 1
        new_mind_map.map_cord_x = model.map_cord_x
        new_mind_map.map_cord_y = model.map_cord_y
        
        ad.saveContext()
        
        return new_mind_map_id
    }
    
    // INSERT INTO DATABASE A PAPER
    func insertPaper(model: Document, map_id: Int32) -> Int32 {
        let new_paper_id = getNewID(forEntity: "Paper")
        let new_paper = Paper(context: context)
        new_paper.id = new_paper_id
        new_paper.title = model.title
        new_paper.author = model.author
        new_paper.abstract = model.abstract
        new_paper.url = model.url
        new_paper.storage_type_id = 1
        new_paper.pdf_url = model.pdf_url
        new_paper.mind_map_id = map_id
        new_paper.importance_id = 1
        new_paper.is_active = 1
        new_paper.is_reference = model.is_reference
        new_paper.paper_cord_x = model.paper_cord_x
        new_paper.paper_cord_y = model.paper_cord_y
        
        ad.saveContext()
        
        return new_paper_id
    }
    
    // INSERT INTO DATABASE A NOTE
    func insertNote(content: String, paper_id: Int32) {
        let new_note_id = getNewID(forEntity: "Note")
        let new_note = Note(context: context)
        new_note.id = new_note_id
        new_note.content = content
        new_note.paper_id = paper_id
        
        ad.saveContext()
    }
    
    //INSERT INTO DATABASE A REFERENCE MAPPING
    func insertReferenceMapping(paper_id: Int32, reference_id: Int32) {
        let new_map = Reference_mapping(context: context)
        new_map.paper_id = paper_id
        new_map.reference_id = reference_id
        
        ad.saveContext()
    }
    
    //FETCH MIND MAP AS MIND_MAP_MODEL CLASS
    func getMindMap(mind_map_id: Int32) -> Mind_map_model {
        let map_model = Mind_map_model()
        let fetch_mind_map = NSFetchRequest<NSFetchRequestResult>(entityName: "Mind_map")
        fetch_mind_map.predicate = NSPredicate(format: "id = %d", mind_map_id)
        
        do {
            let mind_map = try context.fetch(fetch_mind_map) as! [Mind_map]
            
            //fetch the mappings between papers in this mind map
            mind_map_mappings = [Paper_mapping]()
            getPaperMappingsForMindMap(mind_map_id: mind_map[0].value(forKey: "id") as! Int32)
            
            //fetch all papers to be displayed - papers in the mind map
            let map_papers = getPapersForMindMap(mind_map_id: mind_map[0].value(forKey: "id") as! Int32)
            
            map_model.id = mind_map[0].value(forKey: "id") as! Int32
            map_model.title = mind_map[0].value(forKey: "title") as! String
            map_model.topic = mind_map[0].value(forKey: "topic") as! String
            map_model.map_cord_x = mind_map[0].value(forKey: "map_cord_x") as! Float
            map_model.map_cord_y = mind_map[0].value(forKey: "map_cord_y") as! Float
            map_model.mappings = mind_map_mappings
            map_model.papers = map_papers
            
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        return map_model
    }
    
    //FETCH MIND MAP - gets the papers hierachical relations/mappings based on mind map
    //fetches all the papers that are directly connected to the root
    func getPaperMappingsForMindMap(mind_map_id: Int32) {
        let fetch_mapping = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper_mapping")
        fetch_mapping.predicate = NSPredicate(format: "mind_map_id = %d AND is_root_level = 1 AND paper_id = %d", mind_map_id, mind_map_id)
        do{
            let mappings = try context.fetch(fetch_mapping) as! [Paper_mapping]
            
            for map in mappings {
                mind_map_mappings.append(map)
                getPaperMappingsForMindMap(connected: map.value(forKey: "connected_to_id") as! Int32, mind_map_id: mind_map_id)
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    //helping function for the other getPaperMappingsForMindMap function
    //fetches the higher level of papers, papers that are not directly connected to the root
    func getPaperMappingsForMindMap(connected: Int32, mind_map_id: Int32) {
        let fetch_mapping = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper_mapping")
        fetch_mapping.predicate = NSPredicate(format: "mind_map_id = %d AND paper_id = %d AND is_root_level = 0", mind_map_id, connected)
        do{
            let mappings = try context.fetch(fetch_mapping) as! [Paper_mapping]
        
            for map in mappings  {
                mind_map_mappings.append(map)
                getPaperMappingsForMindMap(connected: map.value(forKey: "connected_to_id") as! Int32, mind_map_id: mind_map_id)
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    //FETCH PAPERS RELATED TO A MIND MAP
    func getPapersForMindMap(mind_map_id: Int32) -> [Document] {
        var returnedPapers = [Document]()
        //get all the papers of a mind map that are not references
        let fetch_paper = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper")
        fetch_paper.predicate = NSPredicate(format: "mind_map_id = %d AND is_reference = 0 AND is_active = 1", mind_map_id)
        
        do{
            let papers = try context.fetch(fetch_paper) as! [Paper]
            
            //for each paper create the Document object for that paper and add it to the documents array of the mind map
            for paper in papers  {
                
                let paper_notes = getNotesForPaper(paper_id: paper.value(forKey: "id") as! Int32)
                let paper_refereces = getReferencesForPaper(paper_id: paper.value(forKey: "id") as! Int32, mind_map_id: mind_map_id)
                
                let document = getDocumentFromPaper(paper: paper)
                document.references = paper_refereces
                document.notes = paper_notes
                returnedPapers.append(document)
                
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        return returnedPapers
    }
    
    //FETCH ALL NOTES RELATED TO A PAPER
    func getNotesForPaper(paper_id: Int32) -> [Note] {
        var notes = [Note]()
        let fetch_notes = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetch_notes.predicate = NSPredicate(format: "paper_id = %d", paper_id)
        do {
            notes = try context.fetch(fetch_notes) as! [Note]
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        return notes
    }
    
    //FETCH ALL REFERENCES OF A PAPER (PAPER ENTITIES THAT ARE NOT ADDED TO THE MIND MAP YET or HAVE is_reference = 1)
    func getReferencesForPaper(paper_id: Int32, mind_map_id: Int32) -> [Document] {
        var references = [Document]()
        
        //get the references of that paper by fetching all the corresponding rows from reference_mapping
        //for each reference check for each reference at Paper Entity if its is_reference = 1
        let fetch_reference_mapping = NSFetchRequest<NSFetchRequestResult>(entityName: "Reference_mapping")
        fetch_reference_mapping.predicate = NSPredicate(format: "paper_id = %d", paper_id)
        do {
            let reference_mappings = try context.fetch(fetch_reference_mapping) as! [Reference_mapping]
            
            for reference_mapping in reference_mappings {
                let fetch_reference = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper")
                fetch_reference.predicate = NSPredicate(format: "id = %d AND mind_map_id = %d AND is_reference = 1 AND is_active = 1", reference_mapping.value(forKey: "reference_id") as! Int32, mind_map_id)
                let reference = try context.fetch(fetch_reference) as! [Paper]
                if reference.count > 0 {
                    references.append(getDocumentFromPaper(paper: reference[0]))
                }
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        return references
    }
    
    //ADD REFERENCES OF A PAPER
    func addReferencesForPaper(mind_map_id: Int32, paper_id: Int32, references: [Document]) {
        for reference in references {
            reference.is_reference = 1
            let reference_id = insertPaper(model: reference, map_id: mind_map_id)
            insertReferenceMapping(paper_id: paper_id, reference_id: reference_id)
        }
    }
    
    //UPDATE REFEERENCES OF A PAPER
    //@references CONTAINS NEWLY SELECTED REFERENCES TO BE ADDED AS PAPERS
    func updateReferencesForPaper(paper_id: Int32, references: [Document]) {
        for reference in references {
            let fetch_paper = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper")
            fetch_paper.predicate = NSPredicate(format: "id = %d", reference.id)
            do {
                let paper = try context.fetch(fetch_paper) as! [Paper]
                paper[0].setValue(0, forKey: "is_reference")
                ad.saveContext()
                
                //TODO: create a connection directly to paper_mapping
            } catch {
                let error = error as NSError
                print("\(error)")
            }
        }
    }
    
    //REQUEST REFERENCES FOR PAPER
    func requestReferencesForPaper(paper_id: Int32) {
        let fetch_paper = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper")
        fetch_paper.predicate = NSPredicate(format: "id = %d", paper_id)
        //TODO: request references for paper

//        do {
//            let paper = try context.fetch(fetch_paper) as! [Paper]
//        } catch {
//            let error = error as NSError
//            print("\(error)")
//        }
        
    }
    
    //LIST MIND MAPS FOR THE HOME SCREEN
    func listMindMaps() -> [Mind_map_model] {
        var returnedMaps = [Mind_map_model]()
        let fetch_maps = NSFetchRequest<NSFetchRequestResult>(entityName: "Mind_map")
        do {
            let maps = try context.fetch(fetch_maps) as! [Mind_map]
            for map in maps {
                let temp_map_model = Mind_map_model()
                temp_map_model.id = map.id as Int32
                temp_map_model.title = map.title as String!
                temp_map_model.topic = map.topic as String!
                returnedMaps.append(temp_map_model)
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        return returnedMaps
    }
    
    //TRANSFORM A PAPER ENTITY TO A DOCUMENT MODEL
    private func getDocumentFromPaper(paper: Paper) -> Document {
        let return_document = Document()
        return_document.id = paper.id as Int32
        return_document.abstract = paper.abstract as String!
        return_document.author = paper.author as String!
        return_document.importance_id = paper.importance_id
        return_document.paper_cord_x = paper.paper_cord_x as Float
        return_document.paper_cord_y = paper.paper_cord_y as Float
        return_document.pdf_url = paper.pdf_url as String!
        return_document.title = paper.title as String!
        return_document.url = paper.url as String!
        
        return return_document
    }
    
    //DEFINE FROM THE DATABASE THE BIGGGEST ID FOR MIND MAP/PAPER/NOTE ENTITIES AND ADDS 1 TO IT
    func getNewID(forEntity: String) -> Int32 {
        let fetch_entity = NSFetchRequest<NSFetchRequestResult>(entityName: forEntity)
        
        if forEntity == "Mind_map" {
            let sort = NSSortDescriptor(key: #keyPath(Mind_map.id), ascending: false)
            fetch_entity.sortDescriptors = [sort]
        } else if forEntity == "Paper" {
            let sort = NSSortDescriptor(key: #keyPath(Paper.id), ascending: false)
            fetch_entity.sortDescriptors = [sort]
        } else if forEntity == "Note" {
            let sort = NSSortDescriptor(key: #keyPath(Note.id), ascending: false)
            fetch_entity.sortDescriptors = [sort]
        }
        
        do {
            let entity = try context.fetch(fetch_entity) as! [NSManagedObject]
            
            if entity.count > 0 {
                return entity[0].value(forKey: "id") as! Int32 + 1
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
        return 1
    }
    
    //create mappings between papers
    //if you are connecting the main node to a paper -> is_root = 1 otherwise is_root = 0
    func addConnection(mind_map_id: Int32, from: Int32, to: Int32, text: String, is_root: Int16) {
        let mapping = Paper_mapping(context: context)
        mapping.mind_map_id = mind_map_id
        mapping.paper_id = from
        mapping.connected_to_id = to
        mapping.relation_text = text
        mapping.is_root_level = is_root
        
        ad.saveContext()
    }
    
    //FUNCTIONS THAT NEED REVIEW - INCOMPLETE
    
    // UPDATE MIND MAP
    func updateMindMap(mind_map_id: Int32, model: Mind_map_model) {
        let fetch_mind_map = NSFetchRequest<NSFetchRequestResult>(entityName: "Mind_map")
        fetch_mind_map.predicate = NSPredicate(format: "id = %d", mind_map_id)
        
        do {
            //fetch the mind map
            let mind_map = try context.fetch(fetch_mind_map) as! [NSManagedObject]
            if model.title.isEmpty == false {
                mind_map[0].setValue(model.title, forKey: "title")
            }
            if model.topic.isEmpty == false {
                mind_map[0].setValue(model.topic, forKey: "topic")
            }
            
            ad.saveContext()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
    }
    
    func deletePaper(paper_id: Int32) {
        let fetch_paper = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper")
        fetch_paper.predicate = NSPredicate(format: "id = %d", paper_id)
        
        do {
            let paper = try context.fetch(fetch_paper) as! [NSManagedObject]
            paper[0].setValue(0, forKey: "is_active")
            //TODO: delete also other dependencise from paper_mapping and reference_mapping
            ad.saveContext()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
}
