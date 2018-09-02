//
//  OrdersViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class OrdersViewController: BaseViewController {
    
    let network: NetworkService = NetworkService()
    
    private var orders: [Order] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private let orderIdCell = "OrderTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        obtainData()
    }
    
    private func setup() {
        
        tableView.register(UINib(nibName: orderIdCell, bundle: nil), forCellReuseIdentifier: orderIdCell)
        tableView.tableFooterView = UIView()
        setupLeftMenuButton()
    }
    
    private func obtainData() {
        startAnimating()
        network.obtainOrder(parameters: [:]).done { result in
            self.orders = result.result
            self.stopAnimating()
        }.catch { error in
            self.handleError(error: error, retry: self.obtainData)
            self.stopAnimating()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: orderIdCell, for: indexPath) as! OrderTableViewCell
        cell.setup(with: orders[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let id = markets[indexPath.item].id
//        let sender: [String: Any] = ["id" : markets[indexPath.item].id]
//        self.performSegue(withIdentifier: "info", sender: sender)
    }
    
}

