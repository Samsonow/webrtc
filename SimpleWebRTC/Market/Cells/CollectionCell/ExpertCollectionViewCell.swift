//
//  ExpertCollectionViewCell.swift
//  SimpleWebRTC
//
//  Created by Evgen on 31.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class ExpertCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageExpert: UIImageView!
    @IBOutlet weak var nameExpertLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    @IBOutlet var ratingCollectionImage: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
//        self.layer.shadowColor = UIColor.gray.cgColor
//        self.layer.shadowOpacity = 1
//        self.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.layer.shadowRadius = 4
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ratingCollectionImage.forEach({ $0.isHidden = true })
    }
    
    func setRating(rating: Int) {
        ratingLabel.text = String(rating)
        for i in 0...rating {
            guard i < ratingCollectionImage.count else { return }
            
            ratingCollectionImage[i].isHidden = false
        }

    }

}
