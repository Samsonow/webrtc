//
//  ExpertViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class ExpertViewController: UIViewController {

    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var descriptionView: UITextView!
    
    var expert: Expert!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseButton.layer.cornerRadius = 8
        
        smallImage.layer.cornerRadius = 60
        smallImage.layer.masksToBounds = true
        smallImage.layer.borderWidth = 0
        
        setup()
    }
    
    func setup() {
        if let url = URL(string: expert.image_url) {
            smallImage.kf.setImage(with: url)
            bigImage.kf.setImage(with: url)
        }
        nameLabel.text = expert.name
        ratingLabel.text = "Rating\(expert.rating)"
        
        descriptionView.text = expert.description
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func chooseHelper(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "channel" {
            let vc = segue.destination as! ChannelClientViewController
            vc.expertId = expert.id
        }
    }

    

}
