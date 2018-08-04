//
//  MarketCell.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import Kingfisher

class MarketCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var helpersLabel: UILabel!
    @IBOutlet weak var imageMarket: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with market: Market) {
        nameLabel.text = market.name
        descriptionLabel.text = market.description
        helpersLabel.text = "Available experts: \(market.experts)"
        
        if let url = URL(string: market.image_url) {
            imageMarket.kf.setImage(with: url)
        }
        
    }

}
