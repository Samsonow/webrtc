//
//  MarketInfoViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import PromiseKit

class MarketInfoViewController: BaseViewController {
    
    var marketId: Int = -1
    let networkService = NetworkService()
    var info: MarketInfo?
    var experts: [Expert] = []
    
    let headerCellId: String = "MarketInfoHeaderCell"
    let expertCellID: String = "ExpertCell"
    
    var refreshControl = UIRefreshControl()

    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        evo_drawerController?.screenEdgePanGestureEnabled = true
        self.navigationController?.isNavigationBarHidden = false
        table.register(UINib(nibName: headerCellId, bundle: nil), forCellReuseIdentifier: headerCellId)
        table.register(UINib(nibName: expertCellID, bundle: nil), forCellReuseIdentifier: expertCellID)
        table.tableFooterView = UIView()
        obtainData()
        
        
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        table.addSubview(refreshControl) // not required when using UITableViewController
        
        table.refreshControl = refreshControl

    }
    
    @objc func refresh(sender:AnyObject) {
        obtainData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            self.table.reloadData()
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

extension MarketInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experts.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath) as! MarketInfoHeaderCell
            
            if let urltring = info?.image_url, let url = URL(string: urltring) {
                cell.imageMarket.kf.setImage(with: url)
            }
            cell.nameMarket.text = info?.name
            
            return cell
        }

        
        let cell = tableView.dequeueReusableCell(withIdentifier: expertCellID, for: indexPath) as! ExpertCell
        cell.setup(with: experts[indexPath.item - 1])
        cell.expertDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return 300
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0 { return }
        
        let expert = experts[indexPath.item - 1]
        let sender: [String: Any] = ["expert" : expert]
        self.performSegue(withIdentifier: "expert", sender: sender)
    }
    
}

extension MarketInfoViewController: ExpertDelegate {
    func chooseExpert(cell: UITableViewCell) {
        guard let index = table.indexPath(for: cell) else { return }
        
        let expert = experts[index.item - 1]
        let sender: [String: Any] = ["expert_id" : expert.id]
        self.performSegue(withIdentifier: "channel", sender: sender)

    }
}
