//
//  ProductAlmostReadyCell.swift
//  SimpleWebRTC
//
//  Created by Evgen on 05.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

protocol AlmostReadyDelegate: AnyObject {
    func productOKAction(cell: UITableViewCell)
    func productCancelAction(cell: UITableViewCell)
}


class ProductAlmostReadyCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    weak var delegateAlmostReady: AlmostReadyDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func productOKAction(_ sender: Any) {
        delegateAlmostReady?.productOKAction(cell: self)
    }

    @IBAction func productCancelAction(_ sender: Any) {
        delegateAlmostReady?.productCancelAction(cell: self)
    }
    
}
