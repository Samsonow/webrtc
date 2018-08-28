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
import SwiftPhoneNumberFormatter

class ConfirmPhoneViewController: BaseViewController {
    
    @IBOutlet weak var phoneTextField: PhoneFormattedTextField!
    @IBOutlet weak var bottonButtonConstraint: NSLayoutConstraint!
    let networkService = NetworkService()
    
    var phone: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneTextField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "(###) ###-##-##")
        phoneTextField.prefix = "+7 "
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.bottonButtonConstraint?.constant = 0.0
            } else {
                self.bottonButtonConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    
    @IBAction func didClickRegistration(_ sender: Any) {
        
        guard let phone = phoneTextField.text else {
            return
        }
        
        self.phone = phone
        confirmPhone()

    }
    
    func confirmPhone() {
        let params = ["phone": phone]
        
        networkService.confirmPhone(parameters: params).done { result in
            let sender: [String: Any] = ["phone": self.phone, "pass" : result.result.temp_password]
            self.performSegue(withIdentifier: "confirmCode", sender: sender)
        }.catch { error in
            self.handleError(error: error, retry: self.confirmPhone)
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
