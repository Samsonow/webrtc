//
//  AddProductPopVC.swift
//  SimpleWebRTC
//
//  Created by Evgen on 30.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import SwipeCellKit
import KYDrawerController

class AddProductPopVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var addParemetrs: [String: Any] = [:]
    var parametersdell: [String: Any] = [:]
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 150
    }
    
    let network = NetworkService()
    
    private let acceptTableViewCell: String = "AcceptTableViewCell"
    
    private var products: [Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
        setupPopap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    private func setupPopap() {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    private func setup() {
        
        let acceptNib = UINib(nibName: acceptTableViewCell, bundle: nil)
        tableView.register(acceptNib, forCellReuseIdentifier: acceptTableViewCell)
        
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    self?.tableView.isScrollEnabled = true
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


//MARK: - UITableView
extension AddProductPopVC: UITableViewDelegate, UITableViewDataSource {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = products[indexPath.item]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: acceptTableViewCell, for: indexPath) as! AcceptTableViewCell
        cell.nameLabel.text = product.item
        switch product.getType() {
            
        case .confirmSiller(let price):
            cell.costLabel.text = "\(price) rub price"
            cell.setConfirmSiller()
            
        case .confirmClient(let price):
            cell.costLabel.text = "\(price) rub price"
            cell.setConfirmExpert()
            
        case .none:
            cell.setWithoutPrice()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


extension AddProductPopVC: SwipeTableViewCellDelegate {
    
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
    
    
    private func deleteProduct(id: Int) {
        startAnimating()
        parametersdell = ["id": id]
        dellRequst()
    }
    
    func dellRequst() {
        network.deleteProduct(parameters: parametersdell).done { result in
            //self.handelGetProduct(result.result)
            self.stopAnimating()
        }.catch { error in
            self.handleError(error: error, retry: self.dellRequst)
            self.stopAnimating()
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        let product = products[indexPath.item]
        var options = SwipeOptions()
        
        if let price = product.offered_price {
            return options
        }
        
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        options.expansionStyle = .destructive(automaticallyDelete: false)
        return options
    }
    
}

extension AddProductPopVC: UIGestureRecognizerDelegate {
    
    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (y == fullView && tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        
        return false
    }
    
}

