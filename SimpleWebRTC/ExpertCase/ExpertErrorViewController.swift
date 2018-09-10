//
//  ExpertErrorViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 07.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class ExpertErrorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        evo_drawerController?.screenEdgePanGestureEnabled = false
        //self.evo_drawerController?.openDrawerGestureModeMask = .panningNavigationBar
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        evo_drawerController?.screenEdgePanGestureEnabled = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ExpertMainViewController")
        let nav = UINavigationController(rootViewController: controller)
        evo_drawerController?.mainViewController = nav
        
        evo_drawerController?.setDrawerState(.closed, animated: true)
    
       // evo_drawerController?.setCenter(nav, withCloseAnimation: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        //self.evo_drawerController?.openDrawerGestureModeMask = .panningNavigationBar
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
