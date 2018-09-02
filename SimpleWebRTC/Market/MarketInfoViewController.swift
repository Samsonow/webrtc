//
//  MarketInfoViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import PromiseKit
import Kingfisher

class MarketInfoViewController: BaseViewController {
    
    var marketId: Int = -1
    let networkService = NetworkService()
    var info: MarketInfo? {
        didSet {
            nameLabel.text = info?.name
            if let url = URL(string: (info?.image_url)!) {
                imageMarket.kf.setImage(with: url)
            }
        }
    }
    var experts: [Expert] = []
    
    private let expertCollectionViewCell = "ExpertCollectionViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var imageMarket: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        evo_drawerController?.screenEdgePanGestureEnabled = true

        obtainData()
        
        setupCollection()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupCollection() {
        collectionView.register(UINib(nibName: expertCollectionViewCell, bundle: nil),
                                forCellWithReuseIdentifier: expertCollectionViewCell)
    }
    
    @objc func refresh(sender:AnyObject) {
        obtainData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func closeVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func obtainData() {
        let params = ["id": marketId]
        startAnimating()
        networkService.obtainMarketInfo(parameters: params).then { result -> Promise<Result<[Expert]>> in
            self.info = result.result
            let params = ["market_id": self.marketId]
            return self.networkService.obtainExperts(parameters: params)
        }.done { result in
            self.experts = result.result
            self.collectionView.reloadData()
            self.stopAnimating()
        }.catch { error in
            self.stopAnimating()
            self.handleError(error: error, retry: self.obtainData)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "expert" , let data = sender as? [String: Any] {
            let vc = segue.destination as! ExpertViewController
            vc.expert = data["expert"] as! Expert
        }
        
        if segue.identifier == "channel" , let data = sender as? [String: Any] {
            let vc = segue.destination as! ChannelClientViewController
            vc.expertId = data["expert_id"] as! Int
        }
    }
    
    @IBAction func unindToVC1 (segue: UIStoryboardSegue) {}

}

extension MarketInfoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return experts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: expertCollectionViewCell,
                                                      for: indexPath) as! ExpertCollectionViewCell
        
        let expert = experts[indexPath.section]
        
        if let url = URL(string: expert.image_url) {
            cell.imageExpert.kf.setImage(with: url)
        }
        
        cell.nameExpertLabel.text = expert.name
        cell.setRating(rating: expert.rating)
        
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 4
        cell.layer.shadowOpacity = 0.4
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthCell: CGFloat = 150.0
        let heightCell = self.collectionView.frame.height - 20
        
        return CGSize(width: widthCell, height: heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let index = indexPath.section
        let expert = experts[index]
        let sender: [String: Any] = ["expert" : expert]
        self.performSegue(withIdentifier: "expert", sender: sender)
    }
    
}

extension MarketInfoViewController: ExpertDelegate {
    func chooseExpert(cell: UITableViewCell) {
//        guard let index = table.indexPath(for: cell) else { return }
//
//        let expert = experts[index.item - 1]
//        let sender: [String: Any] = ["expert_id" : expert.id]
//        self.performSegue(withIdentifier: "channel", sender: sender)

    }
}
