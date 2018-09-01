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

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var expertDelegate: ExpertDelegate?
    
    var experts: [Expert] = [] {
        
        didSet {
           collectionView.reloadData()
        }

    }
    private let expertCollectionViewCell = "ExpertCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: expertCollectionViewCell, bundle: nil),
                                forCellWithReuseIdentifier: expertCollectionViewCell)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func didPress(_ sender: Any) {
        expertDelegate?.chooseExpert(cell: self)
    }

}

extension ExpertCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return experts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: expertCollectionViewCell,
                                                      for: indexPath) as! ExpertCollectionViewCell
        
        let expert = experts[indexPath.row]
        
        if let url = URL(string: expert.image_url) {
            cell.imageExpert.kf.setImage(with: url)
        }
        
        cell.nameExpertLabel.text = expert.name
        cell.setRating(rating: expert.rating)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let widthCell: CGFloat = 150.0
        let heightCell = self.frame.height - 20
        
        return CGSize(width: widthCell, height: heightCell)
    }
    
}
