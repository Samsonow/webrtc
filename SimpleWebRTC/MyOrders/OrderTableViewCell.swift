//
//  OrderTableViewCell.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var marketIdLabel: UILabel!
    @IBOutlet weak var helperLabel: UILabel!
    @IBOutlet weak var productsLabel: UILabel!
    @IBOutlet weak var costLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup(with order: Order) {
        dateLabel.text = order.delivery_started ?? "Неизвестная дата"
        marketIdLabel.text = "Market ID: \(order.market_id)"
        helperLabel.text = "Helper: \(order.market_id)"
        productsLabel.text = "Products: \(order.items.count)"
        costLable.text = "\(order.total_cost) rub"
        
        //    <Text style={[iStyle.item.date]}>{`${item.delivery_started}`}</Text>
        //    <Text style={[iStyle.item.graylil]}>{`Market ID: ${item.market_id}`}</Text>
        //    <Text style={[iStyle.item.graylil]}>{`Helper: ${item.expert.name}`}</Text>
        //    <Text style={[iStyle.item.shoppingList]}>{`Products: ${item.items.length}`}</Text>
        //    <Text style={[iStyle.item.price]}>{`${item.total_cost} rub`}</Text>
    }
}
