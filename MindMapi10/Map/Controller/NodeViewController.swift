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
    // CONSTANT
    let width:CGFloat = 200
    let height:CGFloat = 110
    //
    
    // CREATE MIND MAP
    var shouldCreateMindMap = Bool()
    var MindMap = Mind_map_model()
    let transaction = DBTransactions()
    //
    
    // GRAPH MODEL
    var nodes = [NodeCustomView]()
    var nodesRelationMap: [[Bool]] = Array(repeating: Array(repeating: false, count: 100), count: 100)
    
    var edgeFromNode = NodeCustomView()
    var edgeToNode = NodeCustomView()
    //
    
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    var effect:UIVisualEffect!
    
    // MARK: - Notes Sub View
    @IBOutlet var notesSubView: UIView!
    @IBOutlet weak var notesSubViewTitle: UILabel!
    @IBOutlet weak var txtNotesInSubView: UITextView!
    //
    
    //DELEGATES
    var mindMapDelegate:MindMapListDelegate?
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settings()
        /*//TEST ---------------------
        let g = GenerateData()
        g.deleteGeneratedData()
        
        let importexport: DBImportExport = DBImportExport()
        importexport.importMindMap(mind_map_title: "Haptic Feedback")
        
        let db = DBTransactions()
        let list = db.listMindMaps()
        MindMap = list.first!
        
        shouldCreateMindMap = false */
        //----------------
        
        createMindMap(mindMap: MindMap, isNewMap: shouldCreateMindMap)
            
        shouldCreateMindMap = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //IBACTIONS
    @IBAction func btnAddAction(_ sender: Any) {
        //TODO
    }
    
    
    @IBAction func btnExportAction(_ sender: Any) {
        let export = DBImportExport()
        export.exportMindMap(mind_map_id: MindMap.id)
    }
    
    
    @IBAction func btnCloseNotes(_ sender: Any) {
        animateOut()
    }
    //
    
    
    func settings(){
        effect = visualEffect.effect
        visualEffect.effect = nil
        
        self.notesSubView.layer.borderWidth = 1
        self.notesSubView.layer.cornerRadius = 10
        self.notesSubView.layer.borderColor = UIColor.blue.cgColor
    }
    
    func putLabelOnScreen(text:String, x: CGFloat, y:CGFloat, angle:CGFloat)-> UITextField{
        let textField = UITextField(frame: CGRect(x: x, y: y, width: 120, height: 30))
        textField.textAlignment = .center
        textField.text = text
        
        self.view.addSubview(textField)
        return textField
    }
    
    func drawMindMap(_ mindMap: Mind_map_model,_ view:UIView){
        //top-left point's coordinates
        let startingPointX = CGFloat(mindMap.map_cord_x) - (self.width/2)
        let startingPointY = CGFloat(mindMap.map_cord_y) - (self.height/2)
        //
        
        let rootNode = self.initRootNode(nodeInfo: mindMap, frame: CGRect(x:startingPointX,y:startingPointY, width:self.width, height:self.height))
        view.addSubview(rootNode)
        
        mindMap.papers.forEach { doc in
            let node = self.initNode(nodeinfo: doc, frame: CGRect(x:CGFloat(doc.paper_cord_x),y: CGFloat(doc.paper_cord_y), width:self.width, height:self.height))
            view.addSubview(node)
        }
        
        mindMap.mappings.forEach{ mapping in
            if mapping.is_root_level == 1 {
                self.edgeFromNode = rootNode
                self.edgeToNode = nodes.first(where: {$0.document.id == mapping.connected_to_id})!
            }
            else{
                self.edgeFromNode = nodes.first(where: {$0.document.id == mapping.paper_id})!
                self.edgeToNode = nodes.first(where: {$0.document.id == mapping.connected_to_id})!
            }
            
            nodesRelationMap[edgeFromNode.tag][edgeToNode.tag] = true
            nodesRelationMap[edgeToNode.tag][edgeFromNode.tag] = true
            
            self.drawArrow(from: self.edgeFromNode, to: self.edgeToNode, text:mapping.relation_text!, tailWidth: 2, headWidth: 6, headLength: 9)
        }
        
    }
    
    @objc func edgeToIncomeNodeAction(_ sender: UIButton){
        self.edgeToNode = nodes[sender.tag]
        
        nodesRelationMap[edgeFromNode.tag][edgeToNode.tag] = true
        nodesRelationMap[edgeToNode.tag][edgeFromNode.tag] = true
        
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
        let node = nodes[sender.tag]
        
        var text = String()
        node.document.notes.forEach{note in
            text.append("\n \(note.content!)")
        }
        
        txtNotesInSubView.text = text
        notesSubViewTitle.text = node.lblTitle.text
        self.view.bringSubview(toFront: self.visualEffect)
        //txtNotesInSubView.sizeToFit()
        animateIn()
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
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        //
        
        // DRAW Links again
        for index in 0..<nodesRelationMap[nodeIndex].count{
            if nodesRelationMap[nodeIndex][index] {
                nodes.forEach{ node in
                    if node.tag == index {
                        edgeToNode = node
                        self.drawArrow(from: self.edgeFromNode, to: self.edgeToNode, text:" ", tailWidth: 2, headWidth: 6, headLength: 9)
                    }
                }
            }
        }
        //
    }
    
    private func drawArrow(from: NodeCustomView, to: NodeCustomView, text:String, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat ){
        let arrow = UIBezierPath.arrow(from: from.center, to: to.center, tailWidth: tailWidth, headWidth: headWidth, headLength: headLength)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = arrow.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1.0
        
        view.layer.addSublayer(shapeLayer)
        
        let arrowAngle = calculateArrowAngle(from.center, to.center)
        let textField = self.putLabelOnScreen(text: text,x:(from.center.x + to.center.x)/2 , y: (to.center.y + from.center.y)/2, angle: arrowAngle)
        
        from.outgoingEdgeLayers.append(Arrow(shapeLayer, textField))
        to.incommingEdgeLayers.append(Arrow(shapeLayer, textField))
        
        self.view.bringSubview(toFront: from)
        self.view.bringSubview(toFront: to)
        self.view.bringSubview(toFront: textField)
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

// MATH OPERATIONS
extension NodeViewController {
    private func calculateArrowAngle(_ point1: CGPoint,_ point2: CGPoint)->CGFloat{
        let hipotenuz = self.distance(point1, point2)
        let cater = self.distance(point1, CGPoint(x:point2.x, y:point1.y))
        let angle = acos(Double(cater/hipotenuz)) * 180 / .pi
        print(angle)
        
        return CGFloat(angle)
    }
    
    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
}

// ANIMATION
extension NodeViewController {
    func animateIn(){
        self.view.addSubview(notesSubView)
        notesSubView.center = self.view.center
        
        notesSubView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        notesSubView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.visualEffect.effect = self.effect
            self.visualEffect.isUserInteractionEnabled = true
            self.notesSubView.alpha = 1
            self.notesSubView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.notesSubView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.notesSubView.alpha = 0
            
            self.visualEffect.effect = nil
            self.visualEffect.isUserInteractionEnabled = false
        }) { (success:Bool) in
            self.notesSubView.removeFromSuperview()
        }
    }
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
        
        self.drawMindMap(self.MindMap, self.view)
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
        
        node.btnPdf.isHidden = true
        node.btnNotes.isHidden = true
        node.imgImportance.isHidden = true
        node.contentView.backgroundColor = UIColor.orange
        
        self.initiateNodeActions(node: node)
        
        return node
    }
    
    func initNode(nodeinfo: Document, frame:CGRect)->NodeCustomView{
        let node = NodeCustomView(frame: frame)
        
        nodes.append(node)
        self.initiateNodeIndexTagMapping(node:node)
        
        node.lblTitle.text = nodeinfo.title
        node.lblTopic.isHidden = true
        node.document = nodeinfo
        
        self.initiateNodeActions(node: node)
        
        return node
    }
    
    private func initiateNodeIndexTagMapping(node:NodeCustomView){
        let nodeIndex = nodes.count - 1
        node.tag = nodeIndex
        node.btnOutgoingEdge.tag = nodeIndex
        node.btnIncomeEdge.tag = nodeIndex
        node.btnNotes.tag = nodeIndex
    }
    
    private func initiateNodeActions(node: NodeCustomView){
        node.btnIncomeEdge.addTarget(self, action: #selector(NodeViewController.edgeToIncomeNodeAction(_:)), for: .touchUpInside)
        node.btnOutgoingEdge.addTarget(self, action: #selector(NodeViewController.edgeFromOutgoingNodeAction(_:)), for: .touchUpInside)
        node.btnNotes.addTarget(self, action:
            #selector(NodeViewController.popupNotes(_:)), for: .touchUpInside)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NodeViewController.panGestureRecognizer(_:)))
        node.isUserInteractionEnabled = true
        node.addGestureRecognizer(panGestureRecognizer)
    }
}

