//
//  ProductsViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import SwipeCellKit
import IQKeyboardManager

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
    private let headerProductsCell: String = "HeaderProductsCell"
    
    
    var addProductView: AddProductView?
    var viewFon: UIView?
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        setup()
        obtainData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
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
        
        guard addProductView == nil else { return }
        
        let view = Bundle.main.loadNibNamed("AddProductView", owner: self, options: nil)?.first as! AddProductView
        
        
        let y = self.view.frame.height - (self.view.frame.height / 3)
        view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height / 3)
        view.delegate = self
        
        let viewFon = UIView(frame: self.view.frame)
        
        viewFon.backgroundColor = UIColor.black
        viewFon.alpha = 0.3
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction(sender:)))
        viewFon.addGestureRecognizer(gesture)
        
        self.addProductView = view
        self.viewFon = viewFon
        
        self.view.addSubview(viewFon)
        
        self.view.addSubview(view)
        
//        guard let item = newProductTextField.text else {
//            return
//        }
//        newProductTextField.text = ""
//        addProduct(item: item)
    }
    
    
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        self.addProductView?.removeFromSuperview()
        self.viewFon?.removeFromSuperview()
        self.view.endEditing(true)
        
        addProductView = nil
        viewFon = nil
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            if endFrameY >= UIScreen.main.bounds.size.height {
                
                let y = self.view.frame.height - (self.view.frame.height / 3)
                addProductView?.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height / 3)
            } else {
                
                let y = self.view.frame.height - (self.view.frame.height / 3) - (endFrame?.size.height ?? 0.0)
                addProductView?.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height / 3)
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
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
        tableView.register(UINib(nibName: headerProductsCell, bundle: nil), forCellReuseIdentifier: headerProductsCell)

        tableView.tableFooterView = UIView()
        if isFromDrawer {
            setupLeftMenuButton()
        }
    }
    
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: headerProductsCell, for: indexPath) as! HeaderProductsCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellId, for: indexPath) as! ProductCell
        cell.titleLabel.text = products[indexPath.item - 1].item
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.item == 0 {
            return 100
        }
        return 44
    }
    
}


extension ProductsViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let id = self.products[indexPath.item - 1].id
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

extension ProductsViewController: AddProductDelegate {
    
    func addNewProduct(title: String) {
        addProduct(item: title)
        
        self.addProductView?.removeFromSuperview()
        self.viewFon?.removeFromSuperview()
        self.view.endEditing(true)
        
        addProductView = nil
        viewFon = nil
    }
    
}




