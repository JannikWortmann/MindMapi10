//
//  ViewController.swift
//  MindMapi10
//
//  Created by Sabir Alizada on 1/12/18.
//  Copyright © 2018 Halt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MindMapListDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var mind_maps = [Mind_map_model]()
    let g = GenerateData()
    let db = DBTransactions()
    let ie = DBImportExport()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        g.deleteGeneratedData()
        g.generateData()
        
        mind_maps = db.listMindMaps()
        
    }
    
    @IBAction func createMindMapAction(_ sender: Any) {
        
        let view = iOSPopupCreateNewMap { (title, topic) in
            DispatchQueue.main.async(execute: {() -> Void in
                self.dismiss(animated: true, completion: nil)
                self.navigate(title, topic)
            })
        }
        
        present(view, animated: true, completion: nil)
    }
    

    
    //CREATE NEW MIND MAP
    private func navigate(_ title:String,_ topic:String){
        let nodeViewController = self.storyboard?.instantiateViewController(withIdentifier: "NodeViewController") as! NodeViewController
        
        nodeViewController.shouldCreateMindMap = true
        nodeViewController.mainNodeTitle = title
        nodeViewController.mainNodeTopic = topic
        
        navigationController?.pushViewController(nodeViewController, animated: true)
    }
    
    //LIST MIND MAPS AND SELECT ONE OF THEM
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as? MapCell {
            let mind_map = mind_maps[indexPath.row]
            cell.updateUI(mind_map_model: mind_map)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mind_maps.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let map = mind_maps[indexPath.row]
        
        let nodeViewController = self.storyboard?.instantiateViewController(withIdentifier: "NodeViewController") as! NodeViewController
        
        //TO BE REMOVED
        nodeViewController.shouldCreateMindMap = true
        nodeViewController.mainNodeTitle = map.title
        nodeViewController.mainNodeTopic = map.topic
        /****************************************/
        
        nodeViewController.mind_map = map
        
        navigationController?.pushViewController(nodeViewController, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ImportViewController {
            destination.delegate = self
        }
    }
    
    //DELEGATE FUNCTION FOR THE PROTOCOL MindMapListDelegate
    func onMindMapAdd(new_map: Mind_map_model) {
        mind_maps.append(new_map)
        self.loadView()
    }
    
}

