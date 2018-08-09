//
//  ConfirmCodeViewController.swift
//  SimpleWebRTC
//
//  Created by Zhenya on 03.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

class ConfirmCodeViewController: BaseViewController {
    
    var phone: String!
    var currentPassword: String!
    @IBOutlet weak var codeTextField: UITextField!
    let networkService = NetworkService()
    
    var params: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func didClick(_ sender: Any) {
        guard let code = codeTextField.text else {
            return
        }
        
        params = ["verification_code": code, "phone": phone]
        requst()
    }
    
    func requst() {
        networkService.confirmCode(parameters: params).then { _ -> Promise<Result<Token>> in
            let params:[String: Any] = ["phone": self.phone, "password": self.currentPassword]
            return self.networkService.login(parameters: params)
        }.done { result in
            Storage.shared.setToken(token: result.result.token)
            let sender: [String: Any] = ["pass" : self.currentPassword]
            self.performSegue(withIdentifier: "createUser", sender: sender)
            
        }.catch { error in
            self.handleError(error: error, retry: self.requst)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "createUser" , let data = sender as? [String: Any] {
            var vc = segue.destination as! RegistrationViewController
            vc.currentPassword = data["pass"] as! String
        }
    }

}

