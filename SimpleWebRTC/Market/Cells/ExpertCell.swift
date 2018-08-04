//
//  ExpertCell.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
protocol ExpertDelegate: AnyObject {
    func chooseExpert(cell: UITableViewCell)
}

class ExpertCell: UITableViewCell {

    @IBOutlet weak var imageExpert: UIImageView!
    @IBOutlet weak var nameExpert: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    
    weak var expertDelegate: ExpertDelegate?
    
    override func awakeFromNib() {
        
        imageExpert.layer.cornerRadius = 30
        imageExpert.layer.masksToBounds = true
        imageExpert.layer.borderWidth = 0
        
        chooseButton.layer.cornerRadius = 5
        chooseButton.layer.borderWidth = 0.8
        chooseButton.layer.borderColor = UIColor.gray.cgColor
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func didPress(_ sender: Any) {
        expertDelegate?.chooseExpert(cell: self)
    }
    
    func setup(with expert: Expert) {
        
        if let url = URL(string: expert.image_url) {
            imageExpert.kf.setImage(with: url)
        }
        nameExpert.text = expert.name
        rating.text = "Rating\(expert.rating)"
        
    }
}
