//
//  SecondVC.swift
//  SimpleWebRTC
//
//  Created by Zhenya on 22.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class SecondVC: UIViewController, DelegatbalePage {

    weak var delegate: PageDelegate? 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextAction(_ sender: Any) {
        delegate?.selectNext(viewController: self)
    }

}
