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

class ConfirmPhoneViewController: BaseViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    let networkService = NetworkService()
    
    var phone: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    
    @IBAction func didClickRegistration(_ sender: Any) {
        
        guard let phone = phoneTextField.text else {
            return
        }
        
        self.phone = phone

    }
    
    func confirmPhone() -> () {
        let params = ["phone": phone]
        
        networkService.confirmPhone(parameters: params).done { result in
            let sender: [String: Any] = ["phone": self.phone, "pass" : result.result.temp_password]
            self.performSegue(withIdentifier: "confirmCode", sender: sender)
        }.catch { error in
            self.handleError(error: error, retry: {
                self.confirmPhone()
            })
        }
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmCode" , let data = sender as? [String: Any] {
            var vc = segue.destination as! ConfirmCodeViewController
            vc.phone = data["phone"] as! String
            vc.currentPassword = data["pass"] as! String
        }
    }

}
