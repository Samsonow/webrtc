//
//  FirstVC.swift
//  SimpleWebRTC
//
//  Created by Zhenya on 22.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class FirstVC: UIViewController, DelegatbalePage {

    weak var delegate: PageDelegate? 
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    @IBAction func nextAction(_ sender: Any) {
        delegate?.selectNext(viewController: self)
    }
    
}
