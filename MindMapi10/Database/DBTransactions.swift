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
    
    var formatter = DateFormatter()
    
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
        formatter.dateFormat = "dd-MM-yyyy"
        let map_model = Mind_map_model()
        let fetch_mind_map = NSFetchRequest<NSFetchRequestResult>(entityName: "Mind_map")
        fetch_mind_map.predicate = NSPredicate(format: "id = %d", mind_map_id)
        
        do {
            let mind_map = try context.fetch(fetch_mind_map) as! [Mind_map]
            
            //fetch the mappings between papers in this mind map
            let mind_map_mappings = getPaperMappingsForMindMap(mind_map_id: mind_map[0].value(forKey: "id") as! Int32)
            
            //fetch all papers to be displayed - papers in the mind map
            let map_papers = getPapersForMindMap(mind_map_id: mind_map[0].value(forKey: "id") as! Int32)
            
            map_model.id = mind_map[0].value(forKey: "id") as! Int32
            map_model.title = mind_map[0].value(forKey: "title") as! String
            map_model.topic = mind_map[0].value(forKey: "topic") as! String
            map_model.map_cord_x = mind_map[0].value(forKey: "map_cord_x") as! Float
            map_model.map_cord_y = mind_map[0].value(forKey: "map_cord_y") as! Float
            map_model.creation_date = formatter.string(from: mind_map[0].value(forKey: "creation_date") as! Date)
            
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
    //fetch all the papers that are not connected directly to root
    func getPaperMappingsForMindMap(mind_map_id: Int32) -> [Paper_mapping] {
        var mind_map_mappings = [Paper_mapping]()
        let fetch_mapping = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper_mapping")
        fetch_mapping.predicate = NSPredicate(format: "mind_map_id = %d AND is_root_level = 1 AND paper_id = %d", mind_map_id, mind_map_id)
        do{
            let mappings = try context.fetch(fetch_mapping) as! [Paper_mapping]
            
            for map in mappings {
                mind_map_mappings.append(map)
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }

        let fetch_mapping_2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper_mapping")
        fetch_mapping_2.predicate = NSPredicate(format: "mind_map_id = %d AND is_root_level = 0", mind_map_id)
        do{
            let mappings_2 = try context.fetch(fetch_mapping_2) as! [Paper_mapping]
            
            for map in mappings_2 {
                mind_map_mappings.append(map)
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        return mind_map_mappings
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

                addConnection(mind_map_id: paper[0].mind_map_id, from: paper_id, to: reference.id, text: "   ", is_root: 0)
                
                ad.saveContext()
                
            } catch {
                let error = error as NSError
                print("\(error)")
            }
        }
    }
    
    //LIST MIND MAPS FOR THE HOME SCREEN
    func listMindMaps() -> [Mind_map_model] {
        formatter.dateFormat = "dd-MM-yyyy"
        var returnedMaps = [Mind_map_model]()
        let fetch_maps = NSFetchRequest<NSFetchRequestResult>(entityName: "Mind_map")
        do {
            let maps = try context.fetch(fetch_maps) as! [Mind_map]
            for map in maps {
                let temp_map_model = Mind_map_model()
                temp_map_model.id = map.id as Int32
                temp_map_model.title = map.title as String!
                temp_map_model.topic = map.topic as String!
                temp_map_model.creation_date = formatter.string(from: map.creation_date! as Date)
                temp_map_model.papers = getPapersForMindMap(mind_map_id: map.id)
                temp_map_model.map_cord_x = map.map_cord_x as Float
                temp_map_model.map_cord_y = map.map_cord_y as Float
                temp_map_model.mappings = getPaperMappingsForMindMap(mind_map_id: map.id)
                
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
    
    //CREATE MAPPINGS BETWEEN PAPERS
    //if you are connecting the main node to a paper -> is_root = 1 otherwise is_root = 0
    func addConnection(mind_map_id: Int32, from: Int32, to: Int32, text: String, is_root: Int16) {
        let mapping = Paper_mapping(context: context)
        mapping.mind_map_id = mind_map_id
        mapping.paper_id = from
        mapping.connected_to_id = to
        mapping.relation_text = text
        mapping.is_root_level = is_root
        
        print(mind_map_id, " " , from , " " , to, " " , is_root)
        
        ad.saveContext()
    }
    
    //UPDATE MAPPINGS BETWEEM PAPERS - the text between two connected papers
    func updateConnectionText(mind_map_id: Int32, from: Int32, to: Int32, is_root: Int16, text: String) {
        //searching for a connection between root and a paper
        if is_root == 1 {
            let fetch_mapping = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper_mapping")
            fetch_mapping.predicate = NSPredicate(format: "mind_map_id = %d AND paper_id = %d AND connected_to_id = %d AND is_root_level = %d", mind_map_id, from, to, is_root)
            do {
                let map = try context.fetch(fetch_mapping) as! [Paper_mapping]
                if map.count > 0 {
                    map[0].setValue(text, forKey: "relation_text")
                }
            } catch {
                let error = error as NSError
                print("\(error)")
            }
        } else if is_root == 0 {
            let fetch_mapping1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper_mapping")
            fetch_mapping1.predicate = NSPredicate(format: "mind_map_id = %d AND paper_id = %d AND connected_to_id = %d AND is_root_level = %d", mind_map_id, from, to, is_root)
            
            let fetch_mapping2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper_mapping")
            fetch_mapping2.predicate = NSPredicate(format: "mind_map_id = %d AND paper_id = %d AND connected_to_id = %d AND is_root_level = %d", mind_map_id, to, from, is_root)
            
            do {
                let map1 = try context.fetch(fetch_mapping1) as! [Paper_mapping]
                if map1.count > 0 {
                    map1[0].setValue(text, forKey: "relation_text")
                } else {
                    let map2 = try context.fetch(fetch_mapping2) as! [Paper_mapping]
                    if map2.count > 0 {
                        map2[0].setValue(text, forKey: "relation_text")
                    }
                }
            } catch {
                let error = error as NSError
                print("\(error)")
            }
        }
    }
    
    // UPDATE MIND MAP TITLE
    func updateMindMap(mind_map_id: Int32, title: String) {
        let fetch_mind_map = NSFetchRequest<NSFetchRequestResult>(entityName: "Mind_map")
        fetch_mind_map.predicate = NSPredicate(format: "id = %d", mind_map_id)
        
        do {
            //fetch the mind map
            let mind_map = try context.fetch(fetch_mind_map) as! [NSManagedObject]
            mind_map[0].setValue(title, forKey: "title")
            ad.saveContext()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    //UPDATE MIND MAP TOPIC
    func updateMindMap(mind_map_id: Int32, topic: String) {
        let fetch_mind_map = NSFetchRequest<NSFetchRequestResult>(entityName: "Mind_map")
        fetch_mind_map.predicate = NSPredicate(format: "id = %d", mind_map_id)
        
        do {
            //fetch the mind map
            let mind_map = try context.fetch(fetch_mind_map) as! [Mind_map]
            mind_map[0].setValue(topic, forKey: "topic")
            ad.saveContext()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    //UPDATE PAPER COORDINATES
    func updatePaper(paper_id: Int32, paper_cord_x: Float, paper_cord_y: Float) {
        let fetch_paper = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper")
        fetch_paper.predicate = NSPredicate(format: "id = %d", paper_id)
        
        do {
            let paper = try context.fetch(fetch_paper) as! [Paper]
            paper[0].setValue(paper_cord_x, forKey: "paper_cord_x")
            paper[0].setValue(paper_cord_y, forKey: "paper_cord_y")
            ad.saveContext()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    //UPDATE MIND MAP COORDINATES
    func updateMindMap(mind_map_id: Int32, map_cord_x: Float, map_cord_y: Float) {
        let fetch_map = NSFetchRequest<NSFetchRequestResult>(entityName: "Mind_map")
        fetch_map.predicate = NSPredicate(format: "id = %d", mind_map_id)
        
        do {
            let map = try context.fetch(fetch_map) as! [Mind_map]
            map[0].setValue(map_cord_x, forKey: "map_cord_x")
            map[0].setValue(map_cord_y, forKey: "map_cord_y")
            ad.saveContext()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    
    //DELETE A MIND MAP AND ALL ITS CORESPONDING PAPERS AND RELATIONS
    func deleteMindMap(mind_map_id: Int32) {
        let fetch_mind_map = NSFetchRequest<NSFetchRequestResult>(entityName: "Mind_map")
        fetch_mind_map.predicate = NSPredicate(format: "id = %d", mind_map_id)
        
        do {
            let mind_map = try context.fetch(fetch_mind_map) as! [Mind_map]            
            //fetch the mappings between papers in this mind map
            let mind_map_mappings = getPaperMappingsForMindMap(mind_map_id: mind_map[0].value(forKey: "id") as! Int32)
            
            //fetch all papers to be displayed - papers in the mind map
            let map_papers = getPapersForMindMap(mind_map_id: mind_map[0].value(forKey: "id") as! Int32)
            
            //delete the paper_mappings
            for mapping in mind_map_mappings {
                context.delete(mapping)
                ad.saveContext()
            }
            
            //delete the papers related to a mind map
            for paper in map_papers {
                deletePaperFromMindMap(paper_id: paper.id)
            }
            deleteScreenshot(mind_map_id: mind_map_id)
            context.delete(mind_map[0])
            ad.saveContext()
            
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    //DELETE REFERENCE MAPPINGS FOR A PAPER
    func deleteReferenceMappingForPaper(paper_id: Int32) {
        let fetch_paper = NSFetchRequest<NSFetchRequestResult>(entityName: "Reference_mapping")
        fetch_paper.predicate = NSPredicate(format: "paper_id = %d", paper_id)
        do {
            let paper = try context.fetch(fetch_paper) as! [Reference_mapping]
            for ref in paper {
                context.delete(ref)
                ad.saveContext()
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    //DELETE PAPER FROM MIND MAP
    func deletePaperFromMindMap(paper_id: Int32) {
        let fetch_paper = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper")
        fetch_paper.predicate = NSPredicate(format: "id = %d", paper_id)
        
        do {
            let papers = try context.fetch(fetch_paper) as! [Paper]
            let paper = papers[0]
            
            //delete all paper_mappings of the paper
            deletePaperMappingForPaper(paper: paper)
            
            //delete the reference mappings
            deleteReferenceMappingForPaper(paper_id: paper.id)
            let references = getReferencesForPaper(paper_id: paper.id, mind_map_id: paper.mind_map_id)
            
            //get the references of the paper and set for each reference is_active to 0
            for reference in references {
                deletePaper(paper_id: reference.id)
            }
            
            //delete the related notes
            let notes = getNotesForPaper(paper_id: paper.id)
            for note in notes {
                context.delete(note)
                ad.saveContext()
            }
            
            //delete the paper - set the is_active to 0
            deletePaper(paper_id: paper.id)
            
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    //DELETE A PAPER - SET THE IS_ACTIVE TO 0
    private func deletePaper(paper_id: Int32) {
        let fetch_paper = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper")
        fetch_paper.predicate = NSPredicate(format: "id = %d", paper_id)
        
        do {
            let paper = try context.fetch(fetch_paper) as! [NSManagedObject]
            paper[0].setValue(0, forKey: "is_active")
            ad.saveContext()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func deletePaperMappingForPaper(paper: Paper) {
        let fetch_paper = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper_mapping")
        fetch_paper.predicate = NSPredicate(format: "mind_map_id = %d AND is_root_level = 1 and connected_to_id = %d", paper.mind_map_id, paper.id)
        
        let fetch_paper2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper_mapping")
        fetch_paper2.predicate = NSPredicate(format: "mind_map_id = %d AND is_root_level = 0 and paper_id = %d", paper.mind_map_id, paper.id)
        
        let fetch_paper3 = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper_mapping")
        fetch_paper3.predicate = NSPredicate(format: "mind_map_id = %d AND is_root_level = 0 and connected_to_id = %d", paper.mind_map_id, paper.id)
        
        do {
            let papers = try context.fetch(fetch_paper) as! [Paper_mapping]
            for paper in papers {
                context.delete(paper)
                ad.saveContext()
            }
            
            let papers2 = try context.fetch(fetch_paper2) as! [Paper_mapping]
            for paper2 in papers2 {
                context.delete(paper2)
                ad.saveContext()
            }
            
            let papers3 = try context.fetch(fetch_paper3) as! [Paper_mapping]
            for paper3 in papers3 {
                context.delete(paper3)
                ad.saveContext()
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    
    //DELETE THE SCREENSHOT OF A MIND MAP FROM THE FOLDER
    func deleteScreenshot(mind_map_id: Int32) {
        guard let documentDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Screenshots") else { return }
        
        do{
            if !directoryExistsAtPath(documentDirectoryPath.relativePath) {
                try FileManager.default.createDirectory(atPath: documentDirectoryPath.relativePath, withIntermediateDirectories: true, attributes: nil)
            }
            
            let filePath = documentDirectoryPath.appendingPathComponent("mind_map_\(mind_map_id).png")
            
            if FileManager.default.fileExists(atPath: filePath.absoluteString) {
                try FileManager.default.removeItem(at: filePath)
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    public func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}

