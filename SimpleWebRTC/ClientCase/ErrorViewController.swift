//
//  ErrorViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 05.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import KYDrawerController

class ErrorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        let evo_drawerController = self.navigationController?.parent as? KYDrawerController
        
       
        evo_drawerController?.screenEdgePanGestureEnabled = false
        //self.evo_drawerController?.openDrawerGestureModeMask = .panningNavigationBar

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MarketsViewController")
        let nav = UINavigationController(rootViewController: controller)
        evo_drawerController?.mainViewController = nav

        evo_drawerController?.setDrawerState(.opened, animated: false)
        evo_drawerController?.setDrawerState(.closed, animated: false)
        //performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    
   
    
    override func didReceiveMemoryWarning() {
        //self.evo_drawerController?.openDrawerGestureModeMask = .panningNavigationBar
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
