//
//  iOSTextfieldExtension.swift
//  iOSPopupDialogs
//
//  Created by Jannik Wortmann on 12.01.18.
//  Copyright © 2018 Payload1337. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func addBorder() {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .gray
        self.addSubview(line)
        line.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
