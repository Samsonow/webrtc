//
//  LoginViewController.swift
//  SimpleWebRTC
//
//  Created by Zhenya on 02.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
    @IBAction func didActionLogin(_ sender: Any) {
        
        guard let phone = phoneTextField.text, let pass = passwordTextField.text else {
            return
        }

        let params = ["phone": phone, "password": pass]
    
        networkService.login(parameters: params).done { result in
            Storage.shared.setToken(token: result.result.token)
            self.performSegue(withIdentifier: "login", sender: nil)
        }.catch { error in
            self.handleError(error: error)
        }
    }
    
}
