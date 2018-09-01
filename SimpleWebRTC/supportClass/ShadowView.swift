//
//  File.swift
//  SimpleWebRTC
//
//  Created by Evgen on 01.09.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import Foundation
import UIKit

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
       
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }
}
