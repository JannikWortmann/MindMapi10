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
    
    var nodes = [NodeCustomView]()
    var nodesRelationMap: [[Bool]] = Array(repeating: Array(repeating: false, count: 100), count: 100)
    
    var edgeFromNode = NodeCustomView()
    var edgeToNode = NodeCustomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //drawGraph(height: 150, width:200, self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAddNode(_ sender: Any) {
        drawNode(height:150,width: 200 ,view: self.view)
    }
    
    
    /*func drawGraph(height:CGFloat, width:CGFloat,_ view: UIView){
        //ROOT NODE
        var cursorX = self.view.frame.size.width/2
        var cursorY = self.view.frame.size.height/2
        
        let nodeHeight:CGFloat = height
        let nodeWidth:CGFloat = width
        //parentNode left-top point coordinates
        let startingPointX = self.view.frame.size.width/2 - (nodeWidth/2)
        let startingPointY = self.view.frame.size.height/2 - (nodeHeight/2)
        //
        
        let parentNode = NodeCustomView(frame: CGRect(x:startingPointX,y:startingPointY, width:nodeWidth, height:nodeHeight))
        parentNode.mainLabel.text = "HCI Augmented Reality"
        view.addSubview(parentNode)
        
        // PREPARE for CHILDREN
        var childNodesCountRightOrLeft:CGFloat = 4
        let childNodesPanelHeight = self.view.frame.size.height*3/4 //startingPointY + parentNode.bounds.height/2
        let childNodesPanelStartY = (self.view.frame.size.height - childNodesPanelHeight) * 0.5
        let childNodesDistanceFromParent = (startingPointX + parentNode.bounds.width) * 0.3
        var childNodesDistanceBetweenEach = (childNodesPanelHeight - childNodesCountRightOrLeft * nodeHeight) / (childNodesCountRightOrLeft - 1)
        
        //BUILD RIGHT CHILDREN
        cursorY = childNodesPanelStartY
        cursorX = startingPointX + parentNode.bounds.width + childNodesDistanceFromParent
        for index in 1...Int(childNodesCountRightOrLeft) {
            let node = NodeCustomView(frame: CGRect(x:cursorX,y:cursorY, width:nodeWidth, height:nodeHeight))
            node.mainLabel.text = "Reference " + String(index)
            view.addSubview(node)
            
            //DRAW LINKS
            var from = CGPoint(x: startingPointX + nodeWidth, y: startingPointY + nodeHeight/2)
            var to = CGPoint(x: startingPointX + nodeWidth + childNodesDistanceFromParent/4, y: startingPointY + nodeHeight/2)
            UIBezierPath.drawArrow(from: from, to: to,tailWidth: 2, headWidth: 0, headLength: 0, view: self.view)
            
            from = to
            to = CGPoint(x: startingPointX + nodeWidth + childNodesDistanceFromParent/4, y: cursorY + nodeHeight/2)
            UIBezierPath.drawArrow(from: from, to: to,
                                   tailWidth: 2, headWidth: 0, headLength: 0, view: self.view)
            
            from = to
            to = CGPoint(x: startingPointX + nodeWidth + childNodesDistanceFromParent, y: cursorY + nodeHeight/2)
            UIBezierPath.drawArrow(from: from, to: to,
                                   tailWidth: 2, headWidth: 6, headLength: 8, view: self.view)
            //PUT LABEL ON LINK
            self.putLabelOnScreen(text: "Background",x: from.x + 2,y: from.y,view: view)
            //
            
            cursorY += (childNodesDistanceBetweenEach + nodeHeight)
        }
        
        childNodesCountRightOrLeft = 5
        childNodesDistanceBetweenEach = (childNodesPanelHeight - childNodesCountRightOrLeft * nodeHeight) / (childNodesCountRightOrLeft - 1)
        
        //BUILD LEFT CHILDREN
        cursorY = childNodesPanelStartY
        cursorX = startingPointX - childNodesDistanceFromParent - nodeWidth
        for index in 1...Int(childNodesCountRightOrLeft) {
            let node = NodeCustomView(frame: CGRect(x:cursorX,y:cursorY, width:nodeWidth, height:nodeHeight))
            node.mainLabel.text = "Reference " + String(index)
            view.addSubview(node)
            
            //DRAW LINKS
            var from = CGPoint(x: startingPointX, y: startingPointY + nodeHeight/2)
            var to = CGPoint(x: startingPointX - childNodesDistanceFromParent/4, y: startingPointY + nodeHeight/2)
            UIBezierPath.drawArrow(from: from, to: to,tailWidth: 2, headWidth: 0, headLength: 0, view: self.view)
            
            from = to
            to = CGPoint(x: startingPointX - childNodesDistanceFromParent/4, y: cursorY + nodeHeight/2)
            UIBezierPath.drawArrow(from: from, to: to,
                                   tailWidth: 2, headWidth: 0, headLength: 0, view: self.view)
            
            from = to
            to = CGPoint(x: startingPointX - childNodesDistanceFromParent, y: cursorY + nodeHeight/2)
            UIBezierPath.drawArrow(from: from, to: to,
                                   tailWidth: 2, headWidth: 6, headLength: 8, view: self.view)
            
            //PUT LABEL ON LINK
            self.putLabelOnScreen(text: "Background",x: to.x + 2,y: to.y,view: view)
            //
            //
            
            cursorY += (childNodesDistanceBetweenEach + nodeHeight)
        }
    } */
    
    func putLabelOnScreen(text:String, x: CGFloat, y:CGFloat, angle:CGFloat)-> UILabel{
        let label = UILabel(frame: CGRect(x: x, y: y, width: 120, height: 30))
        label.textAlignment = .center
        label.text = text
        
        self.view.addSubview(label)
        return label
        
       // self.label.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    
    func drawNode(height: CGFloat, width: CGFloat, view:UIView){
        let nodeHeight:CGFloat = height
        let nodeWidth:CGFloat = width
        //parentNode left-top point coordinates
        let startingPointX = self.view.frame.size.width/2 - (nodeWidth/2)
        let startingPointY = self.view.frame.size.height/2 - (nodeHeight/2)
        //
        
        let node = NodeCustomView(frame: CGRect(x:startingPointX,y:startingPointY, width:nodeWidth, height:nodeHeight))
        
        nodes.append(node)
        
        node.mainLabel.text = "HCI Augmented Reality"
        
        node.btnIncomeEdge.addTarget(self, action: #selector(NodeViewController.edgeToIncomeNodeAction(_:)), for: .touchUpInside)
        node.btnOutgoingEdge.addTarget(self, action: #selector(NodeViewController.edgeFromOutgoingNodeAction(_:)), for: .touchUpInside)
        
        let nodeIndex = nodes.count - 1
        node.tag = nodeIndex
        node.btnOutgoingEdge.tag = nodeIndex
        node.btnIncomeEdge.tag = nodeIndex
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NodeViewController.panGestureRecognizer(_:)))
        node.isUserInteractionEnabled = true
        node.addGestureRecognizer(panGestureRecognizer)
        
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
    
    @objc func panGestureRecognizer(_ sender: UIPanGestureRecognizer) {
        let draggedNode = sender.view as! NodeCustomView
        edgeFromNode = draggedNode
        let nodeIndex = draggedNode.tag

        // REMOVE all Links
        draggedNode.incommingEdgeLayers.forEach{ arrow in
            arrow.shape.removeFromSuperlayer()
            arrow.label.removeFromSuperview()
        }
        
        draggedNode.outgoingEdgeLayers.forEach{ arrow in
            arrow.shape.removeFromSuperlayer()
            arrow.label.removeFromSuperview()
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
        let label = self.putLabelOnScreen(text: "Body Research",x:(from.center.x + to.center.x)/2 , y: (to.center.y + from.center.y)/2, angle: arrowAngle)
        
        from.outgoingEdgeLayers.append(Arrow(shapeLayer, label))
        to.incommingEdgeLayers.append(Arrow(shapeLayer, label))
        
        self.view.bringSubview(toFront: from)
        self.view.bringSubview(toFront: to)
        self.view.bringSubview(toFront: label)
    }
    
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
