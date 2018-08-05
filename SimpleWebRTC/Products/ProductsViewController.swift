//
//  ProductsViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import SwipeCellKit

class ProductsViewController: BaseViewController {

    var isFromDrawer: Bool = true
    
    let network: NetworkService = NetworkService()
    
    var parameters: [String: Any] = [:]
    
    var parametersdell: [String: Any] = [:]
    
    private var products: [Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private let productCellId: String = "ProductCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newProductTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        obtainData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    func obtainData() {
        
        network.obtainProducts(parameters: [:]).done { result in
            self.products = result.result
        }.catch { error in
            self.handleError(error: error, retry: self.obtainData)
        }
        
    }
    
    private func addProduct(item: String) {
        startAnimating()
        parameters = ["item":item]
        requst()
    }
    
    func requst() {
        network.addProduct(parameters: parameters).done { result in
            self.products = result.result
            self.stopAnimating()
        }.catch { error in
            self.stopAnimating()
            self.handleError(error: error, retry: self.requst)
        }
    }
    
    @IBAction func addProductAction(_ sender: Any) {
        guard let item = newProductTextField.text else {
            return
        }
        newProductTextField.text = ""
        addProduct(item: item)
    }
    
    private func deleteProduct(id: Int) {
        startAnimating()
        parametersdell = ["id": id]
        dellRequst()
    }
    
    func dellRequst() {
        network.deleteProduct(parameters: parametersdell).done { result in
            self.products = result.result
            self.stopAnimating()
        }.catch { error in
            self.handleError(error: error, retry: self.dellRequst)
            self.stopAnimating()
        }
    }
    
    private func setup() {
        tableView.register(UINib(nibName: productCellId, bundle: nil), forCellReuseIdentifier: productCellId)
        tableView.tableFooterView = UIView()
        if isFromDrawer {
            setupLeftMenuButton()
        }
    }
    
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellId, for: indexPath) as! ProductCell
        cell.titleLabel.text = products[indexPath.item].item
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
    
}

extension ProductsViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let id = self.products[indexPath.item].id
            self.deleteProduct(id: id)
            // handle action by updating model with deletion
            print("test")
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        options.expansionStyle = .destructive(automaticallyDelete: false)
        return options
    }

}



