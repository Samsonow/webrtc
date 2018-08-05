//
//  LoginViewController.swift
//  SimpleWebRTC
//
//  Created by Zhenya on 02.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import PromiseKit

class LoginViewController: BaseViewController {
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let networkService = NetworkService()
    
    var params: [String: Any] = [:]
    
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

        params = ["phone": phone, "password": pass]
        requst()
      
    }
    
    func requst() {
        networkService.login(parameters: params).done { result in
            Storage.shared.setToken(token: result.result.token)
        }.then { _  -> Promise<Result<User>> in
            return self.networkService.obtainUser(parameters: [:])
        }.done { result in
            Storage.shared.user = result.result
            self.gotoDrawer()
            //self.performSegue(withIdentifier: "login", sender: nil)
        }.catch { error in
            self.handleError(error: error, retry: self.requst)
        }
    }
    
    func gotoDrawer() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DrawerController")
            let newWindow = UIWindow()
            appDelegate.replaceWindow(newWindow)
            newWindow.rootViewController = controller
        }
    }
    
}
