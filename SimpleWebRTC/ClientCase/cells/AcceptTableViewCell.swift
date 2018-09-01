//
//  AcceptTableViewCell.swift
//  SimpleWebRTC
//
//  Created by Evgen on 05.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class AcceptTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var confirmImage: UIImageView!
    @IBOutlet weak var wightConfirmImage: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setConfirmExpert() {
        confirmImage.image = UIImage(named: "confirmed1")
        wightConfirmImage.constant = 13
        confirmImage.isHidden = false
    }
    
    func setConfirmSiller() {
        confirmImage.image = UIImage(named: "confirmed2")
        wightConfirmImage.constant = 13
        confirmImage.isHidden = false
    }
    
    func setWithoutPrice() {
     
        wightConfirmImage.constant = 0
        confirmImage.isHidden = true
    }
    
}
