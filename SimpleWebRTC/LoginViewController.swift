//
//  LoginViewController.swift
//  SimpleWebRTC
//
//  Created by Zhenya on 02.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftPhoneNumberFormatter

class LoginViewController: BaseViewController {
    @IBOutlet weak var phoneTextField: PhoneFormattedTextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var bottonButtonConstraint: NSLayoutConstraint!
    let networkService = NetworkService()
    
    var params: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        phoneTextField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "(###) ###-##-##")
        phoneTextField.prefix = "+7 "
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        
        //TODO: Move
//        if let token = Storage.shared.getToken() {
//            startAnimating()
//            networkService.obtainUser(parameters: [:]).map { result -> User in
//                Storage.shared.user = result.result
//                return result.result
//            }.then { user in
//                return self.checkChanel(user: user)
//            }.done {
//                self.stopAnimating()
//                self.gotoDrawer()
//            }.catch{ error in
//
//                if let er = error as? NetworkError {
//                    if case .openCHANNEL(let channel) = er {
//                        channelStart = channel
//                        self.gotoDrawer()
//                        return
//                    }
//                }
//
//                self.stopAnimating()
//                self.handleError(error: error, retry: nil)
//            }
//
//        }

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
    @IBAction func didActionLogin(_ sender: Any) {
        
        guard let phone = phoneTextField.text, let pass = passwordTextField.text else {
            return
        }

        params = ["phone": phone, "password": pass]
        requst()
    }
    
    func requst() {
        Storage.shared.clearToken()
        startAnimating()
        
        networkService.login(parameters: params).done { result in
            Storage.shared.setToken(token: result.result.token)
        }.then { _  -> Promise<Result<User>> in
            return self.networkService.obtainUser(parameters: [:])
        }.map { result -> User in
            Storage.shared.user = result.result
            return result.result
        }.then { user in
            return self.checkChanel(user: user)
        }.done {
            self.stopAnimating()
            self.gotoDrawer()
            //self.performSegue(withIdentifier: "login", sender: nil)
        }.catch { error in
            self.stopAnimating()
            if let er = error as? NetworkError {
                
                if case .openCHANNEL(let channel) = er {
                    channelStart = channel
                    self.gotoDrawer()
                    return
                }
            }
            
            self.handleError(error: error, retry: self.requst)
        }
    }
    
    func gotoDrawer() {
        //self.performSegue(withIdentifier: "login", sender: nil)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DrawerController")
            //let newWindow = UIWindow()
            
            appDelegate.replaceWindow(controller)
            //newWindow.rootViewController = controller
        }
    }
    
    
    func checkChanel(user: User) -> Promise<Void> {
        return Promise { resolver in

            if user.type == .client {
                networkService.getChannelsClient(parameters: [:]).done { result in
                        if result.result.isEmpty {
                            resolver.fulfill(())
                        } else {
                            let channel = result.result[0]
                            let error = NetworkError.openCHANNEL(channel)
                            resolver.reject(error)
                        }
                    }.catch { error in
                        resolver.reject(NetworkError.message(error.localizedDescription))
                    }
            }
            
            if user.type == .expert {
                networkService.getChannels(parameters: [:]).done{ result in
                    if result.result.isEmpty {
                        resolver.fulfill(())
                    } else {
                        let channel = result.result[0]
                        let error = NetworkError.openCHANNEL(channel)
                        resolver.reject(error)
                    }

                }.catch { error in
                    resolver.reject(NetworkError.message(error.localizedDescription))
                }
            }
            if user.type == .seller {
                resolver.fulfill(())
            }
        }
    }
    
}
