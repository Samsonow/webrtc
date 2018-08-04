//
//  MarketsViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class MarketsViewController: BaseViewController {
    
    let network: NetworkService = NetworkService()
    
    private var markets: [Market] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private let mardetIdCell = "MarketCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        obtainData()
        
    }
    
    private func obtainData() {
        
        network.obtainMarkets(parameters: [:]).done { result in
            self.markets = result.result
        }.catch { error in
            self.handleError(error: error)
        }
    
    }
    
    private func setup() {
        tableView.register(UINib(nibName: mardetIdCell, bundle: nil), forCellReuseIdentifier: mardetIdCell)
        tableView.tableFooterView = UIView()
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

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markets.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: mardetIdCell, for: indexPath) as! MarketCell
        cell.setup(with: markets[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let id = markets[indexPath.item].id
        let sender: [String: Any] = ["id" : markets[indexPath.item].id]
        self.performSegue(withIdentifier: "info", sender: sender)
    }
    
}
