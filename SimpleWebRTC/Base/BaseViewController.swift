//
//  BaseViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import DrawerController
import NVActivityIndicatorView

class BaseViewController: UIViewController, NVActivityIndicatorViewable {
    
    func setupLeftMenuButton() {
        let leftDrawerButton = DrawerBarButtonItem(target: self, action: #selector(leftDrawerButtonPress(_:)))
        self.navigationItem.setLeftBarButton(leftDrawerButton, animated: true)

        setupDrawer()
    }
    
    private func setupDrawer() {
        
        self.evo_drawerController?.maximumRightDrawerWidth = 300.0
        self.evo_drawerController?.openDrawerGestureModeMask = .all
        self.evo_drawerController?.closeDrawerGestureModeMask = .all
    }
    
    @objc func leftDrawerButtonPress(_ sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func show(message: String, retry: (()->())?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        if let retry = retry {
            alert.addAction(UIAlertAction(title: "Retry the request", style: .default, handler: { action in
                retry()
            }))
        } else {
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        }
       
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleError(error: Error,  retry: (()->())? ) {
        if let backenderror = error as? NetworkError   {
            if case .message(let msg) = backenderror  {
                self.show(message: msg, retry: nil)
            }
        }
        self.show(message: "Custom error",retry: retry)
    }

}
