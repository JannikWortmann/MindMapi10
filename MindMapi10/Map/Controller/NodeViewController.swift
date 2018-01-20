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
    
    var mainNodeTopic = String()
    var mainNodeTitle = String()
    var shouldCreateMindMap = Bool()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settings()
        
        if shouldCreateMindMap {
            let node = Node(width: 200,
                            height: 110,
                            center: CGPoint(x:self.view.frame.size.width/2, y:self.view.frame.size.height/2),
                            title: mainNodeTitle, topic: mainNodeTopic, type: NodeType.main)
            drawNode(nodeInfo: node, view: self.view)
            
            shouldCreateMindMap = false
        }
        
        // Do any additional setup after loading the view.
        
        //drawGraph(height: 150, width:200, self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func settings(){
        effect = visualEffect.effect
        visualEffect.effect = nil
        
        self.notesSubView.layer.borderWidth = 1
        self.notesSubView.layer.cornerRadius = 10
        self.notesSubView.layer.borderColor = UIColor.blue.cgColor
    }
    
    @IBAction func btnAddNode(_ sender: Any) {
        let node = Node(width: 200,
                        height: 110,
                        center: CGPoint(x:self.view.frame.size.width/2, y:self.view.frame.size.height/2),
                        title: "Augmented Reality", topic: "HCI", type: NodeType.child)
        drawNode(nodeInfo: node, view: self.view)
    }
    
    
    @IBAction func btnCloseNotes(_ sender: Any) {
        animateOut()
    }
    
    func putLabelOnScreen(text:String, x: CGFloat, y:CGFloat, angle:CGFloat)-> UITextField{
        let textField = UITextField(frame: CGRect(x: x, y: y, width: 120, height: 30))
        textField.textAlignment = .center
        textField.text = text
        
        self.view.addSubview(textField)
        return textField
    }
    
    
    func drawNode(nodeInfo: Node, view:UIView){
        //top-left point's coordinates
        let startingPointX = nodeInfo.center.x - (nodeInfo.width/2)
        let startingPointY = nodeInfo.center.y - (nodeInfo.height/2)
        //
        
        let node = self.initNode(nodeInfo: nodeInfo, frame: CGRect(x:startingPointX,y:startingPointY, width:nodeInfo.width, height:nodeInfo.height))
        
        view.addSubview(node)
    }
    
    @objc func edgeToIncomeNodeAction(_ sender: UIButton){
        self.edgeToNode = nodes[sender.tag]
        
        nodesRelationMap[edgeFromNode.tag][edgeToNode.tag] = true
        nodesRelationMap[edgeToNode.tag][edgeFromNode.tag] = true
        
        self.drawArrow(from: self.edgeFromNode, to: self.edgeToNode, tailWidth: 2, headWidth: 6, headLength: 9)
        
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
        
        txtNotesInSubView.text = "1. Custome Note."//"- " + nodes.joined(separator: "\n- ")
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
                         self.drawArrow(from: self.edgeFromNode, to: self.edgeToNode, tailWidth: 2, headWidth: 6, headLength: 9)
                    }
                }
            }
        }
        //
    }
    
    private func drawArrow(from: NodeCustomView, to: NodeCustomView, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat ){
        let arrow = UIBezierPath.arrow(from: from.center, to: to.center, tailWidth: tailWidth, headWidth: headWidth, headLength: headLength)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = arrow.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1.0
        
        view.layer.addSublayer(shapeLayer)
        
        let arrowAngle = calculateArrowAngle(from.center, to.center)
        let textField = self.putLabelOnScreen(text: "Body Research",x:(from.center.x + to.center.x)/2 , y: (to.center.y + from.center.y)/2, angle: arrowAngle)
        
        from.outgoingEdgeLayers.append(Arrow(shapeLayer, textField))
        to.incommingEdgeLayers.append(Arrow(shapeLayer, textField))
        
        self.view.bringSubview(toFront: from)
        self.view.bringSubview(toFront: to)
        self.view.bringSubview(toFront: textField)
    }
    
    private func initNode(nodeInfo: Node, frame: CGRect)->NodeCustomView{
        let node = NodeCustomView(frame: frame)
        
        nodes.append(node)
        let nodeIndex = nodes.count - 1
        node.tag = nodeIndex
        node.btnOutgoingEdge.tag = nodeIndex
        node.btnIncomeEdge.tag = nodeIndex
        
        node.lblTitle.text = nodeInfo.title
        node.lblTopic.text = nodeInfo.topic
        
        if nodeInfo.type == .main {
            node.btnPdf.isHidden = true
            node.btnNotes.isHidden = true
            node.imgImportance.isHidden = true
            node.contentView.backgroundColor = UIColor.orange
        }
        else{
            node.lblTopic.isHidden = true
        }
        
        node.btnIncomeEdge.addTarget(self, action: #selector(NodeViewController.edgeToIncomeNodeAction(_:)), for: .touchUpInside)
        node.btnOutgoingEdge.addTarget(self, action: #selector(NodeViewController.edgeFromOutgoingNodeAction(_:)), for: .touchUpInside)
        node.btnNotes.addTarget(self, action: #selector(NodeViewController.popupNotes(_:)), for: .touchUpInside)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NodeViewController.panGestureRecognizer(_:)))
        node.isUserInteractionEnabled = true
        node.addGestureRecognizer(panGestureRecognizer)
        
        return node
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
