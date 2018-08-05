//
//  ErrorViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 05.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import DrawerController

class ErrorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.evo_drawerController?.openDrawerGestureModeMask = .panningNavigationBar

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    
   
    
    override func didReceiveMemoryWarning() {
        self.evo_drawerController?.openDrawerGestureModeMask = .panningNavigationBar
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
