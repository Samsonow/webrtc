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
        
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        
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
