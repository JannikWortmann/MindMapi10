//
//  iOSPopupCreateNewMap.swift
//  iOSPopupDialogs
//
//  Created by Jannik Wortmann on 12.01.18.
//  Copyright © 2018 Payload1337. All rights reserved.
//

import UIKit

//------------------------------------------------------------------------------------------
//  iOSPopupCreateNewMap
//
//  Usage:
//  1.
//  let view = iOSPopupCreateNewMap()
//
//  2.
//  Pass a callback to the controller instance to get the title and topic when the user continues!
//
//  let view = iOSPopupCreateNewMap { (title, topic) in
//      //Do Stuff
//  }
//
//  Finally push the view to the viewstack with: present(vc:,animated:,completion:)
//
//------------------------------------------------------------------------------------------

class iOSPopupCreateNewMap: UIViewController {
//------------------------------------------------------------------------------------------
    //MARK: UI Variables
    
    
    //----------------------------------------------------------------------------------
    // cMainView
    //----------------------------------------------------------------------------------
    var cMainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    //----------------------------------------------------------------------------------
    // cAddMap
    //----------------------------------------------------------------------------------
    
    var cAddNewMapLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.text = "Add new Mind Map"
        lbl.font = Fonts.gLabelFontBig
        return lbl
    }()
    
    //----------------------------------------------------------------------------------
    // cLabelStackView
    //----------------------------------------------------------------------------------
    var cLabelStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        //stack.spacing = 40.0
        return stack
    }()
    
    //----------------------------------------------------------------------------------
    // cTitle
    //----------------------------------------------------------------------------------
    
    var cTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.setContentHuggingPriority(.required, for: .horizontal)
        lbl.setContentHuggingPriority(.required, for: .vertical)
        lbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        lbl.text = "Title of Map:"
        lbl.font = Fonts.gLabelFontMedium
        return lbl
    }()
    
    var cTitleTextfield: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.addBorder()
        txt.placeholder = "Enter a Map title"
        txt.textAlignment = .left
        txt.font = Fonts.gLabelFontMedium
        return txt
    }()
    
    var cTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //----------------------------------------------------------------------------------
    // cTopic
    //----------------------------------------------------------------------------------
    
    var cTopicLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.setContentHuggingPriority(.required, for: .horizontal)
        lbl.setContentHuggingPriority(.required, for: .vertical)
        lbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        lbl.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        lbl.text = "Topic:"
        lbl.font = Fonts.gLabelFontMedium
        return lbl
    }()
    
    var cTopicTextfield: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.addBorder()
        txt.placeholder = "Enter a Topic"
        txt.textAlignment = .left
        txt.font = Fonts.gLabelFontMedium
        return txt
    }()
    
    var cTopicView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    //----------------------------------------------------------------------------------
    // cContinue
    //----------------------------------------------------------------------------------
    var cContinueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Continue", for: .normal)
        btn.titleLabel?.font = Fonts.gButtonFontBig
        btn.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return btn
    }()
    
//------------------------------------------------------------------------------------------
    //MARK: Class Variables
    var cCallback: createMapCallback?
    

//------------------------------------------------------------------------------------------
    //MARK: Class Functions
    @objc func handleContinue() {
        self.cCallback?(self.cTitleTextfield.text ?? "", self.cTopicTextfield.text ?? "")
    }
    
    
//------------------------------------------------------------------------------------------
    //MARK: UIViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
//------------------------------------------------------------------------------------------
    //MARK: Constructors
    init(pContinueCallback: createMapCallback?) {
        self.cCallback = pContinueCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension iOSPopupCreateNewMap {
//------------------------------------------------------------------------------------------
    //MARK: Init UI
    func setupUI() {
        //----------------------------------------------------------------------------------
        // view
        //----------------------------------------------------------------------------------
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        //----------------------------------------------------------------------------------
        // cMainView
        //----------------------------------------------------------------------------------
        self.view.addSubview(self.cMainView)
        
        self.cMainView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.cMainView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.cMainView.widthAnchor.constraint(equalToConstant: 500).isActive = true
        self.cMainView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        //----------------------------------------------------------------------------------
        // cAddNewMap
        //----------------------------------------------------------------------------------
        self.cMainView.addSubview(self.cAddNewMapLabel)
        
        self.cAddNewMapLabel.centerXAnchor.constraint(equalTo: self.cMainView.centerXAnchor).isActive = true
        self.cAddNewMapLabel.topAnchor.constraint(equalTo: self.cMainView.topAnchor, constant: 8).isActive = true
        //----------------------------------------------------------------------------------
        // cContinue
        //----------------------------------------------------------------------------------
        self.cMainView.addSubview(self.cContinueButton)
        
        self.cContinueButton.centerXAnchor.constraint(equalTo: self.cMainView.centerXAnchor).isActive = true
        self.cContinueButton.bottomAnchor.constraint(equalTo: self.cMainView.bottomAnchor, constant: -8).isActive = true
        //----------------------------------------------------------------------------------
        // cLabelStackView
        //----------------------------------------------------------------------------------
        self.cMainView.addSubview(self.cLabelStackView)
        
        
        self.cLabelStackView.topAnchor.constraint(equalTo: self.cAddNewMapLabel.bottomAnchor, constant: 8).isActive = true
        self.cLabelStackView.bottomAnchor.constraint(equalTo: self.cContinueButton.topAnchor, constant: -8).isActive = true
        self.cLabelStackView.leftAnchor.constraint(equalTo: self.cMainView.leftAnchor, constant: 8).isActive = true
        self.cLabelStackView.rightAnchor.constraint(equalTo: self.cMainView.rightAnchor, constant: -8).isActive = true
        
        //----------------------------------------------------------------------------------
        // cTitleView
        //----------------------------------------------------------------------------------
        self.cLabelStackView.addArrangedSubview(self.cTitleView)
        
        self.cTitleView.leftAnchor.constraint(equalTo: self.cLabelStackView.leftAnchor).isActive = true
        self.cTitleView.rightAnchor.constraint(equalTo: self.cLabelStackView.rightAnchor).isActive = true
        
        self.cTitleView.addSubview(self.cTitleLabel)
        self.cTitleView.addSubview(self.cTitleTextfield)

        //cTitleLabel
        self.cTitleLabel.leftAnchor.constraint(equalTo: self.cTitleView.leftAnchor, constant: 8).isActive = true
        self.cTitleLabel.centerYAnchor.constraint(equalTo: self.cTitleView.centerYAnchor).isActive = true

        //cTitleTextField
        self.cTitleTextfield.leftAnchor.constraint(equalTo: self.cTitleLabel.rightAnchor, constant: 8).isActive = true
        self.cTitleTextfield.centerYAnchor.constraint(equalTo: self.cTitleView.centerYAnchor).isActive = true
        self.cTitleTextfield.rightAnchor.constraint(equalTo: self.cTitleView.rightAnchor, constant: -8).isActive = true
        
        //----------------------------------------------------------------------------------
        // cTopicView
        //----------------------------------------------------------------------------------
        self.cLabelStackView.addArrangedSubview(self.cTopicView)
        self.cTopicView.leftAnchor.constraint(equalTo: self.cLabelStackView.leftAnchor).isActive = true
        self.cTopicView.rightAnchor.constraint(equalTo: self.cLabelStackView.rightAnchor).isActive = true
        
        self.cTopicView.addSubview(self.cTopicLabel)
        self.cTopicView.addSubview(self.cTopicTextfield)

        //cTopicLabel
        self.cTopicLabel.leftAnchor.constraint(equalTo: self.cTopicView.leftAnchor, constant: 8).isActive = true
        self.cTopicLabel.centerYAnchor.constraint(equalTo: self.cTopicView.centerYAnchor).isActive = true

        //cTopicTextfield
        self.cTopicTextfield.leftAnchor.constraint(equalTo: self.cTitleLabel.rightAnchor, constant: 8).isActive = true
        self.cTopicTextfield.centerYAnchor.constraint(equalTo: self.cTopicView.centerYAnchor).isActive = true
        self.cTopicTextfield.rightAnchor.constraint(equalTo: self.cTopicView.rightAnchor, constant: -8).isActive = true
        
        // Gesture to close the view
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissCurrentView(sender:)))
        self.view.addGestureRecognizer(gesture)
    }
}

extension iOSPopupCreateNewMap {
    //Param #1: Title of the Map
    //Param #2: Topic of the Map
    typealias createMapCallback = ((String, String) -> Void)
}

extension iOSPopupCreateNewMap{
    @objc private func dismissCurrentView(sender: UITapGestureRecognizer){
        guard !self.cMainView.bounds.contains(sender.location(in: self.cMainView)) else {
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
