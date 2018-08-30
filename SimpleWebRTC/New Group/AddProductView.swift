//
//  AddProductView.swift
//  SimpleWebRTC
//
//  Created by Evgen on 31.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
protocol AddProductDelegate: AnyObject {
    func addNewProduct(title: String)
}

class AddProductView: UIView {
    weak var delegate: AddProductDelegate?
    
    @IBOutlet weak var nameItemTextField: UITextField!
    
    @IBAction func didSelectAdd(_ sender: Any) {
        delegate?.addNewProduct(title: nameItemTextField.text ?? "")
    }
}
