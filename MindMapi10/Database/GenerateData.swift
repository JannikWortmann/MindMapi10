//
//  GenerateData.swift
//  MindMapTest
//
//  Created by Jona Hebaj on 07.01.18.
//  Copyright © 2018 Jona Hebaj. All rights reserved.
//

import UIKit
import CoreData

public class GenerateData: UIViewController {
    //delete generated test data for user, storage, importance and mind map related tables
    func deleteGeneratedData(){
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        deleteGeneratedDataBasedOnRequest(fetchRequest: fetchRequest1)
        
        let fetchRequest3 = NSFetchRequest<NSFetchRequestResult>(entityName: "Storage")
        deleteGeneratedDataBasedOnRequest(fetchRequest: fetchRequest3)
        
        let fetchRequest4 = NSFetchRequest<NSFetchRequestResult>(entityName: "Importance")
        deleteGeneratedDataBasedOnRequest(fetchRequest: fetchRequest4)
        
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper")
        deleteGeneratedDataBasedOnRequest(fetchRequest: fetchRequest2)
        
        let fetchRequest5 = NSFetchRequest<NSFetchRequestResult>(entityName: "Mind_map")
        deleteGeneratedDataBasedOnRequest(fetchRequest: fetchRequest5)
        
        let fetchRequest6 = NSFetchRequest<NSFetchRequestResult>(entityName: "Paper_mapping")
        deleteGeneratedDataBasedOnRequest(fetchRequest: fetchRequest6)
        
        let fetchRequest7 = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        deleteGeneratedDataBasedOnRequest(fetchRequest: fetchRequest7)
        
        let fetchRequest8 = NSFetchRequest<NSFetchRequestResult>(entityName: "Reference_mapping")
        deleteGeneratedDataBasedOnRequest(fetchRequest: fetchRequest8)
        
    }
    
    func deleteGeneratedDataBasedOnRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>){
        fetchRequest.includesPropertyValues = false
        do {
            let items = try context.fetch(fetchRequest) as! [NSManagedObject]
            for item in items {
                context.delete(item)
            }
            try context.save()
        } catch {
            //error handling
        }
    }
    //generate data about importance, storage and 1 user and two mind maps - with mappings and references
    func generateData() {
        let storage = Storage(context: context)
        storage.id = 1
        storage.name = "ACM"
        
        let storage2 = Storage(context: context)
        storage2.id = 2
        storage2.name = "iCloud"
        
        let imp = Importance(context: context)
        imp.id = 1
        imp.level = "Not assigned"
        
        let imp2 = Importance(context: context)
        imp2.id = 2
        imp2.level = "Low"
        
        let imp3 = Importance(context: context)
        imp3.id = 3
        imp3.level = "Medium"
        
        let imp4 = Importance(context: context)
        imp4.id = 4
        imp4.level = "High"
        
        let user = User(context: context)
        user.id = 1
        user.name = "Jona"
        user.surname = "Hebaj"
        user.email = "jona@g.c"
        user.institution = "RWTH"
        
        let mind_map = Mind_map(context: context)
        mind_map.id = 1
        mind_map.title = "Haptic Feedback Title"
        mind_map.user_id = 1
        mind_map.topic = "haptic"
        mind_map.map_cord_x = 3.5
        mind_map.map_cord_y = 3.5
        
        let paper = Paper(context: context)
        paper.id = 1
        paper.title = "Haptic Feedback paper 1"
        paper.author = "Author1 Surname"
        paper.abstract = "This is abstract"
        paper.storage_type_id = 1
        paper.url = "www.this.that"
        paper.pdf_url = "www.this.pdf"
        paper.importance_id = 1
        paper.is_active = 1
        paper.mind_map_id = 1
        paper.paper_cord_x = 3.7
        paper.paper_cord_y = 3.7
        paper.is_reference = 0
        
        let note = Note(context: context)
        note.id = 1
        note.content = "This is a note"
        note.paper_id = 1
        
        let note1 = Note(context: context)
        note.id = 2
        note1.content = "This is another note"
        note1.paper_id = 1
        
        let paper2 = Paper(context: context)
        paper2.id = 2
        paper2.title = "Haptic Feedback paper 2"
        paper2.author = "Author2 Surname"
        paper2.abstract = "This is abstract"
        paper2.storage_type_id = 1
        paper2.url = "www.this.that2"
        paper2.pdf_url = "www.this.pdf2"
        paper2.importance_id = 1
        paper2.is_active = 1
        paper2.mind_map_id = 1
        paper2.paper_cord_x = 3.8
        paper2.paper_cord_y = 3.8
        paper2.is_reference = 0
        
        let paper3 = Paper(context: context)
        paper3.id = 3
        paper3.title = "Haptic Feedback paper 3"
        paper3.author = "Author3 Surname"
        paper3.abstract = "This is abstract"
        paper3.storage_type_id = 1
        paper3.url = "www.this.that3"
        paper3.pdf_url = "www.this.pdf3"
        paper3.importance_id = 1
        paper3.is_active = 1
        paper3.mind_map_id = 1
        paper3.paper_cord_x = 3.9
        paper3.paper_cord_y = 3.9
        paper3.is_reference = 1
        
        let paper4 = Paper(context: context)
        paper4.id = 4
        paper4.title = "Haptic Feedback paper 4"
        paper4.author = "Author4 Surname"
        paper4.abstract = "This is abstract"
        paper4.storage_type_id = 1
        paper4.url = "www.this.that4"
        paper4.pdf_url = "www.this.pdf4"
        paper4.importance_id = 1
        paper4.is_active = 1
        paper4.mind_map_id = 1
        paper4.paper_cord_x = 3.94
        paper4.paper_cord_y = 3.94
        paper4.is_reference = 1
        
        //SECOND MIND MAP
        let mind_map2 = Mind_map(context: context)
        mind_map2.id = 2
        mind_map2.title = "Force Input Feedback Title"
        mind_map2.user_id = 1
        mind_map2.topic = "force input"
        mind_map2.map_cord_x = 7.5
        mind_map2.map_cord_y = 7.5
        
        let paper5 = Paper(context: context)
        paper5.id = 5
        paper5.title = "Force Input Paper 5"
        paper5.author = "Author5 Surname"
        paper5.abstract = "This is abstract"
        paper5.storage_type_id = 1
        paper5.url = "www.this.that5"
        paper5.pdf_url = "www.this.pdf5"
        paper5.importance_id = 1
        paper5.is_active = 1
        paper5.mind_map_id = 2
        paper5.paper_cord_x = 7.55
        paper5.paper_cord_y = 7.55
        paper5.is_reference = 0
        
        let paper6 = Paper(context: context)
        paper6.id = 6
        paper6.title = "Force Input Paper 6"
        paper6.author = "Author6 Surname"
        paper6.abstract = "This is abstract"
        paper6.storage_type_id = 1
        paper6.url = "www.this.that6"
        paper6.pdf_url = "www.this.pdf6"
        paper6.importance_id = 1
        paper6.is_active = 1
        paper6.mind_map_id = 2
        paper6.paper_cord_x = 7.6
        paper6.paper_cord_y = 7.6
        paper6.is_reference = 1
        
        let paper7 = Paper(context: context)
        paper7.id = 7
        paper7.title = "Force Input Paper 8"
        paper7.author = "Author8 Surname"
        paper7.abstract = "This is abstract"
        paper7.storage_type_id = 1
        paper7.url = "www.this.that8"
        paper7.pdf_url = "www.this.pdf8"
        paper7.importance_id = 1
        paper7.is_active = 1
        paper7.mind_map_id = 2
        paper7.paper_cord_x = 7.7
        paper7.paper_cord_y = 7.7
        paper7.is_reference = 0
        
        //mappings in the first mind map
        let ref1 = Paper_mapping(context: context)
        ref1.mind_map_id = 1
        ref1.is_root_level = 1
        ref1.paper_id = 1
        ref1.connected_to_id = 1
        ref1.relation_text = "Rel1"
        
        let ref2 = Paper_mapping(context: context)
        ref2.mind_map_id = 1
        ref2.is_root_level = 1
        ref2.paper_id = 1
        ref2.connected_to_id = 2
        ref2.relation_text = "Rel2"
        
        //        let ref3 = Paper_mapping(context: context)
        //        ref3.mind_map_id = 1
        //        ref3.is_root_level = 0
        //        ref3.paper_id = 2
        //        ref3.connected_to_id = 3
        //        ref3.relation_text = "Rel3"
        
        //        let ref4 = Paper_mapping(context: context)
        //        ref4.mind_map_id = 1
        //        ref4.is_root_level = 0
        //        ref4.paper_id = 2
        //        ref4.connected_to_id = 4
        //        ref4.relation_text = "Rel4"
        
        let ref5 = Paper_mapping(context: context)
        ref5.mind_map_id = 2
        ref5.is_root_level = 1
        ref5.paper_id = 2
        ref5.connected_to_id = 5
        ref5.relation_text = "Rel5"
        
        let ref6 = Paper_mapping(context: context)
        ref6.mind_map_id = 2
        ref6.is_root_level = 1
        ref6.paper_id = 2
        ref6.connected_to_id = 7
        ref6.relation_text = "Rel6"
        
        //        let ref7 = Paper_mapping(context: context)
        //        ref7.mind_map_id = 1
        //        ref7.is_root_level = 0
        //        ref7.paper_id = 5
        //        ref7.connected_to_id = 6
        //        ref7.relation_text = "Rel7"
        
        //References
        
        let pr = Reference_mapping(context: context)
        pr.paper_id = 2
        pr.reference_id = 3
        
        let pr2 = Reference_mapping(context: context)
        pr2.paper_id = 2
        pr2.reference_id = 4
        
        let pr3 = Reference_mapping(context: context)
        pr3.paper_id = 5
        pr3.reference_id = 6
        
        ad.saveContext()
    }
}
