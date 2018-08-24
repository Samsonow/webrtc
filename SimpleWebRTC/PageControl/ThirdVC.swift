//
//  ThirdVC.swift
//  SimpleWebRTC
//
//  Created by Zhenya on 22.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class ThirdVC: UIViewController, DelegatbalePage {

    weak var delegate: PageDelegate? 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startAction(_ sender: Any) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            Storage.shared.isFirstLaunch = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateInitialViewController()!
            appDelegate.replaceWindow(controller)

        }
    }

}
