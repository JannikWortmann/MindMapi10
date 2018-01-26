//
//  NodeViewController.swift
//  MindMapi10
//
//  Created by Sabir Alizada on 1/12/18.
//  Copyright © 2018 Halt. All rights reserved.
//
//TODO
//Deactivate linking if user changed his mind.

import UIKit

class NodeViewController: UIViewController {
    // CREATE MIND MAP
    var shouldCreateMindMap = Bool()
    var MindMap = Mind_map_model()
    var notRelatedDocuments = [NodeCustomView]()
    let transaction = DBTransactions()
    //
    
    // GRAPH MODEL
    var nodes = [NodeCustomView]()
    var nodesRelationMap: [[Bool]] = Array(repeating: Array(repeating: false, count: 100), count: 100)
    
    var edgeFromNode = NodeCustomView()
    var edgeToNode = NodeCustomView()
    
    var pdfViewSenderNodeTag = Int()
    //
    
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    var effect:UIVisualEffect!
    
    // MARK: - Notes Sub View
    var currentNoteViewNode = NodeCustomView()
    @IBOutlet var notesSubView: UIView!
    @IBOutlet weak var notesSubViewTitle: UILabel!
    @IBOutlet weak var txtNotesInSubView: UITextView!
    @IBOutlet weak var newNoteText: UITextField!
    //
    
    //DELEGATES
    var mindMapDelegate: MindMapListDelegate?
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settings()
    
        //var spinner = self.displaySpinner(onView: self.view)
        
        createMindMap(mindMap: MindMap, isNewMap: shouldCreateMindMap)
        
        shouldCreateMindMap = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnExportAction(_ sender: Any) {
        let export = DBImportExport()
        export.exportMindMap(mind_map_id: MindMap.id)
    }
    
    
    @IBAction func btnCloseNotes(_ sender: Any) {
        animateOut()
    }
    //
    
    
    @IBAction func addNote(_ sender: Any) {
        if let text = self.newNoteText.text, !text.isEmpty
        {
            transaction.insertNote(content: text, paper_id: self.currentNoteViewNode.document.id)
            
            self.currentNoteViewNode.document.notes = transaction.getNotesForPaper(paper_id: self.currentNoteViewNode.document.id)
            
            var noteText = String()
            self.currentNoteViewNode.document.notes.forEach{note in
                noteText.append("\n \(note.content!)")
            }
            
            txtNotesInSubView.text = noteText
        }
        
        self.newNoteText.text = ""
    }
    
    func settings(){
        effect = visualEffect.effect
        visualEffect.effect = nil
        
        self.notesSubView.layer.borderWidth = 1
        self.notesSubView.layer.cornerRadius = 10
        self.notesSubView.layer.borderColor = UIColor.blue.cgColor
        
        if !shouldCreateMindMap {
            MindMap = transaction.getMindMap(mind_map_id: MindMap.id)
        }
    }
    
    func putLabelOnScreen(text:String, x: CGFloat, y:CGFloat, angle:CGFloat)-> UITextField{
        let textField = UITextField(frame: CGRect(x: x, y: y, width: 120, height: 30))
        textField.textAlignment = .center
        textField.text = text
        
        self.view.addSubview(textField)
        return textField
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? SearchViewController {
            nav.delegate = self
        }
    }
    
    private func getRelationTextOfNodes(from: NodeCustomView, to: NodeCustomView)-> String {
        var result = String()
        
            self.MindMap.mappings.forEach{ link in
                if (link.is_root_level == 1){
                    if (link.paper_id == self.MindMap.id && link.connected_to_id == to.document.id) ||
                        (link.connected_to_id == self.MindMap.id && link.paper_id == to.document.id){
                        result = link.relation_text!
                    }
                    if (link.paper_id == self.MindMap.id && link.connected_to_id == from.document.id) ||
                        (link.connected_to_id == self.MindMap.id && link.paper_id == from.document.id){
                        result = link.relation_text!
                    }
                }
                else{
                    if (link.paper_id == from.document.id && link.connected_to_id == to.document.id) ||
                        (link.connected_to_id == from.document.id && link.paper_id == to.document.id){
                        result = link.relation_text!
                    }
                }
            }
        
        return result
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

// DB LOGIC
extension NodeViewController {
    func createMindMap(mindMap: Mind_map_model, isNewMap:Bool){
        
        if isNewMap{
            self.MindMap.map_cord_x = Float(self.view.frame.size.width/2)
            self.MindMap.map_cord_y = Float(self.view.frame.size.height/2)
            
            mindMap.id = transaction.insertMindMap(model: mindMap)
            mindMapDelegate?.onMindMapAdd(new_map: mindMap)
        }
        
        self.drawMindMap(mindMap, self.view)
    }
    
    func addNewRelationDB(from: NodeCustomView, to:NodeCustomView, text:String){
        if (from.isRootNode){
            transaction.addConnection(mind_map_id: MindMap.id, from: MindMap.id, to: to.document.id, text: text, is_root: 1)
        }
        else if (to.isRootNode) {
            transaction.addConnection(mind_map_id: MindMap.id, from: MindMap.id, to: from.document.id, text: text, is_root: 1)
        }
        else{
            transaction.addConnection(mind_map_id: MindMap.id, from: from.document.id,
                                      to: to.document.id, text: text, is_root: 0)
        }
        
        self.MindMap = transaction.getMindMap(mind_map_id: self.MindMap.id)
    }
}

// NODE INIT
extension NodeViewController{
    func initRootNode(nodeInfo: Mind_map_model, frame: CGRect)->NodeCustomView{
        let node = NodeCustomView(frame: frame)
        
        nodes.append(node)
        self.initiateNodeIndexTagMapping(node:node)
        
        node.lblTitle.text = nodeInfo.title
        node.lblTopic.text = nodeInfo.topic
        node.isRootNode = true
        
        node.btnPdf.isHidden = true
        node.btnNotes.isHidden = true
        node.importanceView.isHidden = true
//        node.imgImportance.isHidden = true
        node.contentView.backgroundColor = UIColor.orange
        
        self.initiateNodeActions(node: node)
        
        return node
    }
    
    func initNode(nodeinfo: Document, frame:CGRect)->NodeCustomView{
        let node = NodeCustomView(frame: frame)
        
        nodes.append(node)
        self.initiateNodeIndexTagMapping(node:node)
        
        node.lblTitle.text = nodeinfo.title
        node.authorsLabel.text = nodeinfo.author
        
        node.authorsLabel.sizeToFit()
        node.lblTitle.sizeToFit()
        
        // Calculating dynamic height
        let sumHeight = node.lblTitle.frame.height + node.authorsLabel.frame.height + 24.0
        
        print(node.authorsLabel.frame.height)
        
        node.lblTopic.isHidden = true
        node.isRootNode = false
        node.document = nodeinfo
        
        node.frame.size.height = sumHeight
        
        self.initiateNodeActions(node: node)
        
        return node
    }
    
    private func initiateNodeIndexTagMapping(node:NodeCustomView){
        let nodeIndex = nodes.count - 1
        node.tag = nodeIndex
        node.btnOutgoingEdge.tag = nodeIndex
        node.btnIncomeEdge.tag = nodeIndex
        node.btnNotes.tag = nodeIndex
        node.btnPdf.tag = nodeIndex
    }
    
    private func initiateNodeActions(node: NodeCustomView){
        node.btnIncomeEdge.addTarget(self, action: #selector(NodeViewController.edgeToIncomeNodeAction(_:)), for: .touchUpInside)
        node.btnOutgoingEdge.addTarget(self, action: #selector(NodeViewController.edgeFromOutgoingNodeAction(_:)), for: .touchUpInside)
        node.btnNotes.addTarget(self, action:
            #selector(NodeViewController.popupNotes(_:)), for: .touchUpInside)
        node.btnPdf.addTarget(self, action: #selector(NodeViewController.openPDFView(_:)), for: .touchUpInside)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NodeViewController.panGestureRecognizer(_:)))
        node.isUserInteractionEnabled = true
        node.addGestureRecognizer(panGestureRecognizer)
    }
}

// Node BUTTON ACTIONS
extension NodeViewController{
    @objc func edgeToIncomeNodeAction(_ sender: UIButton){
        self.edgeToNode = nodes[sender.tag]
        
        nodesRelationMap[edgeFromNode.tag][edgeToNode.tag] = true
        nodesRelationMap[edgeToNode.tag][edgeFromNode.tag] = true
        
        self.addNewRelationDB(from: self.edgeFromNode, to: self.edgeToNode, text: "Background")
        
        self.drawArrow(from: self.edgeFromNode, to: self.edgeToNode, text:"Background", tailWidth: 2, headWidth: 6, headLength: 9)
        
        for index in 0..<nodes.count{
            nodes[index].btnOutgoingEdge.isHidden = false
            nodes[index].btnIncomeEdge.isHidden = true
        }
    }
    
    @objc func edgeFromOutgoingNodeAction(_ sender: UIButton){
        self.edgeFromNode = nodes[sender.tag]
        
        for indexLink in 0..<nodesRelationMap[sender.tag].count {
            if (indexLink != sender.tag) && (!nodesRelationMap[sender.tag][indexLink]) {
                for indexNode in 0..<nodes.count{
                    if indexLink == nodes[indexNode].tag {
                        nodes[indexNode].btnOutgoingEdge.isHidden = true
                        nodes[indexNode].btnIncomeEdge.isHidden = false
                    }
                }
            }
        }
    }
    
    //TODO
    @objc func popupNotes(_ sender: UIButton){
        self.currentNoteViewNode = nodes[sender.tag]
        
        var text = String()
        self.currentNoteViewNode.document.notes.forEach{note in
            text.append("\n \(note.content!)")
        }
        
        txtNotesInSubView.text = text
        notesSubViewTitle.text = self.currentNoteViewNode.lblTitle.text
        self.view.bringSubview(toFront: self.visualEffect)
        //txtNotesInSubView.sizeToFit()
        animateIn()
    }
    
    @objc func openPDFView(_ sender: UIButton){
        let node = nodes[sender.tag]
        // Necessary for finding correct node after return to this controller
        self.pdfViewSenderNodeTag = sender.tag
        
        //Create new node for sending
        let doc = Document()
        doc.id = node.document.id
        doc.references = transaction.getReferencesForPaper(paper_id: doc.id, mind_map_id: self.MindMap.id)
        
        // Filter the references. Sending only did not link references.
        for nodeIndex in 0..<nodesRelationMap[sender.tag].count {
            if (nodeIndex != sender.tag) && (!nodesRelationMap[sender.tag][nodeIndex]) {
                doc.references = doc.references.filter({$0.id != nodes[nodeIndex].document.id})
            }
        }
    }
    
    @objc func panGestureRecognizer(_ sender: UIPanGestureRecognizer) {
        let draggedNode = sender.view as! NodeCustomView
        edgeFromNode = draggedNode
        let nodeIndex = draggedNode.tag
        
        // REMOVE all Links
        draggedNode.incommingEdgeLayers.forEach{ arrow in
            arrow.shape.removeFromSuperlayer()
            arrow.textField.removeFromSuperview()
        }
        
        draggedNode.outgoingEdgeLayers.forEach{ arrow in
            arrow.shape.removeFromSuperlayer()
            arrow.textField.removeFromSuperview()
        }
        //
        
        //DRAG
        let translation = sender.translation(in: self.view)
        let x = sender.view!.center.x + translation.x
        let y = sender.view!.center.y + translation.y
        sender.view!.center = CGPoint(x: x, y: y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        if sender.state == .ended{
            if draggedNode.isRootNode{
                transaction.updateMindMap(mind_map_id: MindMap.id, map_cord_x: Float(x), map_cord_y: Float(y))
            }
            else {
                transaction.updatePaper(paper_id: draggedNode.document.id, paper_cord_x: Float(x), paper_cord_y: Float(y))
            }
        }
        //
        
        // DRAW Links again
        for index in 0..<nodesRelationMap[nodeIndex].count{
            if nodesRelationMap[nodeIndex][index] {
                nodes.forEach{ node in
                    if node.tag == index {
                        edgeToNode = node
                        self.drawArrow(from: self.edgeFromNode, to: self.edgeToNode,
                                       text:getRelationTextOfNodes(from: self.edgeFromNode, to: self.edgeToNode),
                                       tailWidth: 2, headWidth: 6, headLength: 9)
                    }
                }
            }
        }
    }
}


//DRAW MIND MAP AND NODES
extension NodeViewController: UIGraphDelegate{
    func drawArrow(from: NodeCustomView, to: NodeCustomView, text:String, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat ){
        let arrow = UIBezierPath.arrow(from: from.center, to: to.center, tailWidth: tailWidth, headWidth: headWidth, headLength: headLength)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = arrow.cgPath
        shapeLayer.strokeColor = UIColor(red: 192.0/255, green: 216.0/255.0, blue: 242.0/255.0, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 1.0
        
        view.layer.addSublayer(shapeLayer)
        
        let arrowAngle = self.calculateArrowAngle(from.center, to.center)
        let textField = self.putLabelOnScreen(text: text,x:(from.center.x + to.center.x)/2 , y: (to.center.y + from.center.y)/2, angle: arrowAngle)
        
        from.outgoingEdgeLayers.append(Arrow(shapeLayer, textField))
        to.incommingEdgeLayers.append(Arrow(shapeLayer, textField))
        
        self.view.bringSubview(toFront: from)
        self.view.bringSubview(toFront: to)
        self.view.bringSubview(toFront: textField)
    }
    
    func drawMindMap(_ mindMap: Mind_map_model,_ view:UIView){
        //top-left point's coordinates
        let startingPointX = CGFloat(mindMap.map_cord_x) - (NodeConfig.width/2)
        let startingPointY = CGFloat(mindMap.map_cord_y) - (NodeConfig.height/2)
        //
        
        let rootNode = self.initRootNode(nodeInfo: mindMap, frame: CGRect(x:startingPointX,y:startingPointY, width:NodeConfig.width, height:NodeConfig.height))
        view.addSubview(rootNode)
        
        mindMap.papers.forEach { doc in
            let node = self.initNode(nodeinfo: doc, frame: CGRect(x:CGFloat(doc.paper_cord_x),y: CGFloat(doc.paper_cord_y), width:NodeConfig.width, height:NodeConfig.height))
            view.addSubview(node)
        }
        
        var from: NodeCustomView = NodeCustomView()
        var to: NodeCustomView = NodeCustomView()
        
        mindMap.mappings.forEach{ mapping in
            print("Mapping from = \(mapping.paper_id)  to = \(mapping.connected_to_id) and isRoot=\(mapping.is_root_level)")
            if mapping.is_root_level == 1 {
                from = rootNode
                to = nodes.first(where: {$0.document.id == mapping.connected_to_id})!
            }
            else{
                from = nodes.first(where: {$0.document.id == mapping.paper_id})!
                to = nodes.first(where: {$0.document.id == mapping.connected_to_id})!
            }
            
            nodesRelationMap[from.tag][to.tag] = true
            nodesRelationMap[to.tag][from.tag] = true
            
            self.drawArrow(from: from, to: to, text:mapping.relation_text!, tailWidth: 2, headWidth: 6, headLength: 9)
        }
    }
    
    func drawNode(doc: Document){
        doc.paper_cord_x = Float(self.view.bounds.width/2)
        doc.paper_cord_y = Float(self.view.bounds.height/2)
        
        //top-left point's coordinates
        let startingPointX = CGFloat(doc.paper_cord_x) - (NodeConfig.width/2)
        let startingPointY = CGFloat(doc.paper_cord_y) - (NodeConfig.height/2)
        //
        
        let node = self.initNode(nodeinfo: doc,
                                 frame: CGRect(x:startingPointX,y:startingPointY, width:NodeConfig.width, height:NodeConfig.height))
        node.document.id = transaction.insertPaper(model: doc, map_id: self.MindMap.id)
        self.view.addSubview(node)
    }
    
    func drawLinkedNodes(from:Document){
        //top-left point's coordinates
        let startingPointX = self.view.bounds.width/2 - (NodeConfig.width/2)
        let startingPointY = self.view.bounds.height/2 - (NodeConfig.height/2)
        //
        
        self.edgeFromNode = nodes[self.pdfViewSenderNodeTag]
        
        from.references.forEach{ doc in
            let node = self.initNode(nodeinfo: doc, frame: CGRect(x:startingPointX,y: startingPointY, width:NodeConfig.width, height:NodeConfig.height))
            view.addSubview(node)
            
            self.edgeToNode = node
            
            self.drawArrow(from: self.edgeFromNode, to: self.edgeToNode, text:"   ", tailWidth: 2, headWidth: 6, headLength: 9)
            
            self.addNewRelationDB(from: self.edgeFromNode, to: self.edgeToNode, text: "   ")
        }
        
        self.MindMap = transaction.getMindMap(mind_map_id: self.MindMap.id)
    }
}

