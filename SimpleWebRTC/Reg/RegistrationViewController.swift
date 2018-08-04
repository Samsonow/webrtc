//
//  RegistrationViewController.swift
//  SimpleWebRTC
//
//  Created by Zhenya on 03.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

class RegistrationViewController: BaseViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    var currentPassword: String!
    
    let networkService = NetworkService()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func didClick(_ sender: Any) {
        
        guard let name = nameTextField.text, let pass = passTextField.text else {
            return
        }
        
        var params: [String: Any]  = ["name": name]
        networkService.setName(parameters: params).done { _ in
            params = ["current_password": self.currentPassword,"new_password": pass, "new_password2": pass]
            self.networkService.setPass(parameters: params)
        }.done {
            self.performSegue(withIdentifier: "test", sender: nil)
        }.catch { error in
            self.handleError(error: error)
        }
        
        
    }    
    
}

