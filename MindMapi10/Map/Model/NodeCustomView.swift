//
//  NodeCustomView.swift
//  DemoUiProgramicallyBuild
//
//  Created by Sabir Alizada on 1/9/18.
//  Copyright © 2018 Halt. All rights reserved.
//

import UIKit

@IBDesignable class NodeCustomView: UIView {
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var btnOutgoingEdge: UIButton!
    @IBOutlet weak var btnIncomeEdge: UIButton!
    @IBOutlet var contentView: UIView!
    
    var incommingEdgeLayers = [Arrow]()
    var outgoingEdgeLayers = [Arrow]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        Bundle.main.loadNibNamed(String(describing: NodeCustomView.self), owner: self, options: nil)
        guard let contentView = contentView else { return }
        contentView.frame = bounds
        self.addSubview(contentView)
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
