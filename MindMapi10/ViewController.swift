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
        
        //g.deleteGeneratedData()
        //g.generateData()
        
        mind_maps = db.listMindMaps()
        //print(mind_maps.count)
        //print("We got LIST")
        //print(mind_maps.count)
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createMindMapAction(_ sender: Any) {
        
        let view = iOSPopupCreateNewMap { (title, topic) in
            DispatchQueue.main.async(execute: {() -> Void in
                self.dismiss(animated: true, completion: nil)
                self.navigate(title, topic)
            })
        }
        
        view.modalPresentationStyle = .overCurrentContext
        
        present(view, animated: true, completion: nil)
    }
    
    private func navigate(_ title:String,_ topic:String){
        let nodeViewController = self.storyboard?.instantiateViewController(withIdentifier: "NodeViewController") as! NodeViewController
        
        nodeViewController.MindMap.title = title
        nodeViewController.MindMap.topic = topic
        nodeViewController.shouldCreateMindMap = true
        nodeViewController.mindMapDelegate = self
        
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
        
        nodeViewController.MindMap = map
        nodeViewController.mindMapDelegate = self
        
        navigationController?.pushViewController(nodeViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addAction = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let map = self.mind_maps[indexPath.row]
            self.db.deleteMindMap(mind_map_id: map.id)
            print("deleted ", map.id)
            
            self.onMindMapAdd(new_map: map)
            
            //confirmation feedback
            let advTimeGif = UIImage.gif(name: "checkmark")
            let imageView2 = UIImageView(image: advTimeGif)
            imageView2.frame = CGRect(x: self.view.frame.size.width - 90.0, y: 50.0, width: 100, height: 100.0)
            self.view.addSubview(imageView2)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                imageView2.removeFromSuperview()
            })
            
        }
        
        addAction.backgroundColor = UIColor.red
        
        return [addAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ImportViewController {
            destination.delegate = self
        }
    }
    
    //DELEGATE FUNCTION FOR THE PROTOCOL MindMapListDelegate
    func onMindMapAdd(new_map: Mind_map_model) {
        mind_maps = db.listMindMaps()
        //self.loadView()
        tableView.reloadData()
    }
}

