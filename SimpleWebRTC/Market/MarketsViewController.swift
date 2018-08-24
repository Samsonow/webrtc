//
//  MarketsViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import KYDrawerController
class MarketsViewController: BaseViewController {

    let network: NetworkService = NetworkService()
    
    var refreshControl = UIRefreshControl()
    
    var chooseMarketId: Int = 0
    
    private var markets: [Market] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private let mardetIdCell = "MarketCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        tableView.refreshControl = refreshControl
        super.viewDidLoad()
        setup()
        obtainData()
        
        startAnimating()
        
    }
    
    @objc func refresh(sender:AnyObject) {
        obtainData()
    }
    
    private func obtainData() {
        startAnimating()
        network.obtainMarkets(parameters: [:]).done { result in
            self.markets = result.result
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            
        }.catch { error in
            self.refreshControl.endRefreshing()
            self.stopAnimating()
            self.handleError(error: error, retry: self.obtainData)
        }
    
    }
    
    private func setup() {
        tableView.register(UINib(nibName: mardetIdCell, bundle: nil), forCellReuseIdentifier: mardetIdCell)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        setupLeftMenuButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "info" , let data = sender as? [String: Any] {
            var vc = segue.destination as! MarketInfoViewController
            vc.marketId = data["id"] as! Int
        }
    }

}


extension MarketsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return markets.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: mardetIdCell, for: indexPath) as! MarketCell
        cell.setup(with: markets[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Storage.shared.user?.type == .expert {
            chooseMarketId = markets[indexPath.section].id
            setMarket()
            return
        }
        
        let id = markets[indexPath.item].id
        let sender: [String: Any] = ["id" : markets[indexPath.section].id]
        self.performSegue(withIdentifier: "info", sender: sender)
    }
    
    private func setMarket() {
        let parameters: [String: Any] = ["market_id": chooseMarketId]
        network.setMarket(parameters: parameters).done {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ExpertMainViewController")
            let nav = UINavigationController(rootViewController: controller)
            evo_drawerController?.mainViewController = nav
            evo_drawerController?.setDrawerState(.closed, animated: true)
        }.catch { error in
            self.handleError(error: error, retry: self.setMarket)
        }
    }
    
}
