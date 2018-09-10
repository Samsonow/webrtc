//
//  ExpertViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class ExpertViewController: BaseViewController {

    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var descriptionView: UITextView!
    
    @IBOutlet var ratingCollectionImage: [UIImageView]!
    
    var expert: Expert!
    var channelGet: ChannelGet?
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    @IBAction func closeViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setup() {
        if let url = URL(string: expert.image_url) {
            smallImage.kf.setImage(with: url)
        }
        nameLabel.text = expert.name
        ratingLabel.text = "\(expert.rating)"
        
        setRating(with: expert.rating)
        
        descriptionView.text = expert.description
        
    }
    
    func setRating(with rating: Int) {
        ratingLabel.text = String(rating)
        for i in 0...rating {
            guard i < ratingCollectionImage.count else { return }
            
            ratingCollectionImage[i].isHidden = false
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func chooseHelper(_ sender: Any) {
        
        let params: [String: Any] = ["expert_id": expert.id]
        networkService.obtainChannel(parameters: params).done { result in
            let chanel = result.result
            self.channelGet = ChannelGet(form: chanel)
            self.performSegue(withIdentifier: "callExpert", sender: sender)
        }.catch { error in
            self.handleError(error: error, retry: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "callExpert" {
            guard let channel = channelGet else { return }
            let vc = segue.destination as! ChannelClientViewController
            vc.channel = channel
        }
    }

}
