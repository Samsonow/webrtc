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
        
        if let token = Storage.shared.getToken() {
            startAnimating()
            networkService.obtainUser(parameters: [:]).map { result -> User in
                Storage.shared.user = result.result
                return result.result
            }.then { user in
                return self.checkChanel(user: user)
            }.done {
                self.stopAnimating()
                self.gotoDrawer()
            }.catch{ error in
                
                if let er = error as? NetworkError {
                    if case .openCHANNEL(let channel) = er {
                        channelStart = channel
                        self.gotoDrawer()
                        return
                    }
                }
                
                self.stopAnimating()
                self.handleError(error: error, retry: nil)
            }
                
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
            self.gotoDrawer()
            //self.performSegue(withIdentifier: "login", sender: nil)
        }.catch { error in
            
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
