//
//  LoginViewController.swift
//  SimpleWebRTC
//
//  Created by Zhenya on 02.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import PromiseKit
import SideMenu

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
        

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MarketsViewController")
        let nav = UINavigationController(rootViewController: controller)
        
        
        let left = storyboard.instantiateViewController(withIdentifier: "DroweViewController")
            //let newWindow = UIWindow()
   
        
            SideMenuManager.default.menuLeftNavigationController = left
 
            // Enable gestures. The left and/or right menus must be set up above for these to work.
            // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
            SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
            SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
            
            // Set up a cool background image for demo purposes
            SideMenuManager.default.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
   
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
