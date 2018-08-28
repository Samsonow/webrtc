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

class ConfirmCodeViewController: BaseViewController, UITextFieldDelegate {
    
    var phone: String!
    var currentPassword: String!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var bottonButtonConstraint: NSLayoutConstraint!
    let networkService = NetworkService()
    
    var currentNumberCode: Int = 0
    var currentCode: String = ""
    
    @IBOutlet weak var firstCircle: UIView!
    @IBOutlet weak var secondCircle: UIView!
    @IBOutlet weak var thirdCircle: UIView!
    @IBOutlet weak var fourthCircle: UIView!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    
    var params: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.delegate = self
        
        firstCircle.backgroundColor = UIColor.white
        
        firstCircle.layer.cornerRadius = firstCircle.frame.size.width/2
        firstCircle.layer.borderColor = UIColor.black.cgColor
        firstCircle.layer.borderWidth = 2.0
        
        secondCircle.layer.cornerRadius = secondCircle.frame.size.width/2
        
        thirdCircle.layer.cornerRadius = thirdCircle.frame.size.width/2
        
        fourthCircle.layer.cornerRadius = fourthCircle.frame.size.width/2
        
        
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
    
    
    @IBAction func didClick(_ sender: Any) {
        guard let code = codeTextField.text, currentCode.count == 4 else {
            show(message: "Не валидный код", retry: nil)
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
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if currentCode.count > 4 && !string.isEmpty {
            return false
        }
        if string == "" {
            currentCode = String(currentCode.dropLast())
            
            if currentCode.count == 0 {
                firstCircle.backgroundColor = UIColor.white
                
                firstCircle.layer.cornerRadius = firstCircle.frame.size.width/2
                firstCircle.layer.borderColor = UIColor.black.cgColor
                firstCircle.layer.borderWidth = 2.0
                firstLabel.text = ""
                
                secondCircle.backgroundColor = UIColor.gray
                secondCircle.layer.borderColor = UIColor.gray.cgColor
            }
            
            if currentCode.count == 1 {
                
                secondCircle.backgroundColor = UIColor.white
                secondCircle.layer.cornerRadius = firstCircle.frame.size.width/2
                secondCircle.layer.borderColor = UIColor.black.cgColor
                secondCircle.layer.borderWidth = 2.0
                
                secondLabel.text = ""
                
                thirdCircle.backgroundColor = UIColor.gray
                thirdCircle.layer.borderColor = UIColor.gray.cgColor
            }
            
            if currentCode.count == 2 {
                
                thirdCircle.backgroundColor = UIColor.white
                thirdCircle.layer.cornerRadius = firstCircle.frame.size.width/2
                thirdCircle.layer.borderColor = UIColor.black.cgColor
                thirdCircle.layer.borderWidth = 2.0
                
                thirdLabel.text = ""
                
                fourthCircle.backgroundColor = UIColor.gray
                fourthCircle.layer.borderColor = UIColor.gray.cgColor
            }
            
            if currentCode.count == 3 {
                
                fourthCircle.backgroundColor = UIColor.white
                fourthCircle.layer.cornerRadius = firstCircle.frame.size.width/2
                fourthCircle.layer.borderColor = UIColor.black.cgColor
                fourthCircle.layer.borderWidth = 2.0
                
                fourthLabel.text = ""
                
            }
            
            
            
            return true
        } else {
            currentCode += string
        }
        
        
        if currentCode.count == 1 {
            firstCircle.layer.cornerRadius = 0
            firstCircle.layer.borderColor = UIColor.white.cgColor
            firstLabel.text = "\(Array(currentCode)[0])"
            firstCircle.backgroundColor = UIColor.white
            
            secondCircle.backgroundColor = UIColor.white
            secondCircle.layer.borderColor = UIColor.black.cgColor
            secondCircle.layer.borderWidth = 2.0
        }
        
        if currentCode.count == 2 {
            secondCircle.layer.cornerRadius = 0
            secondCircle.layer.borderColor = UIColor.white.cgColor
            secondLabel.text = "\(Array(currentCode)[1])"
            secondCircle.backgroundColor = UIColor.white
            
            thirdCircle.backgroundColor = UIColor.white
            thirdCircle.layer.borderColor = UIColor.black.cgColor
            thirdCircle.layer.borderWidth = 2.0
        }
        
        if currentCode.count == 3 {
            thirdCircle.layer.cornerRadius = 0
            thirdCircle.layer.borderColor = UIColor.white.cgColor
            thirdLabel.text = "\(Array(currentCode)[2])"
            thirdCircle.backgroundColor = UIColor.white
            
            fourthCircle.backgroundColor = UIColor.white
            fourthCircle.layer.borderColor = UIColor.black.cgColor
            fourthCircle.layer.borderWidth = 2.0
        }
        
        if currentCode.count == 4 {
            fourthCircle.layer.cornerRadius = 0
            fourthCircle.layer.borderColor = UIColor.white.cgColor
            fourthLabel.text = "\(Array(currentCode)[3])"
            fourthCircle.backgroundColor = UIColor.white
        }
        
        return true
    }


}

