//
//  SellerViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 08.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class SelllerViewController: BaseViewController {
    
    
   // @IBOutlet weak var containerView: UIView!
    
    
    var channel: ChannelGet?
    private let productAlmostReadyCell: String = "ProductAlmostReadyCell"
    private let acceptTableViewCell: String = "AcceptTableViewCell"
    var newtworkService = NetworkService()
    
    var timer: Timer?
    
    var products: [SellerProduct] = [] {
        didSet {

            products.forEach({ (product) in
                let type = product.getType()
                if case .none(let price) = type {
                    self.showConfirm(with: price, id: product.id )
                }
            })
            //tableView.reloadData()
        }
    }
    
    
    private func showConfirm(with price: Float, id: Int) {
        
        let alert = UIAlertController(title: "Предлагаемая цена", message: "\(price) руб", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
            
            self.confirmPrice(with: id)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { action in

           self.reject(with: id)
            
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    private func confirmPrice(with id: Int) {
        let params = ["item_id": id]

        startAnimating()

        newtworkService.acceptOfferSellers(parameters: params).done { _ in
            self.stopAnimating()
            //self.products = result.result
        }.catch { error in
            self.stopAnimating()
            self.handleError(error: error, retry: nil)
        }
    }
    
    private func reject(with id: Int) {

        let params = ["item_id": id]

        startAnimating()

        newtworkService.rejectOfferSellers(parameters: params).done { _ in
            //self.products = result.result
            self.stopAnimating()
        }.catch { error in
            self.stopAnimating()
            self.handleError(error: error, retry: nil)
        }
    }
    
    

   // @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        evo_drawerController?.setDrawerState(.opened, animated: false)
        evo_drawerController?.setDrawerState(.closed, animated: false)
        super.viewDidLoad()
        setupLeftMenuButton()
        
//        tableView.tableFooterView = UIView()
//
//        let productAlmost = UINib(nibName: productAlmostReadyCell, bundle: nil)
//        tableView.register(productAlmost, forCellReuseIdentifier: productAlmostReadyCell)
//
//        let acceptNib = UINib(nibName: acceptTableViewCell, bundle: nil)
//        tableView.register(acceptNib, forCellReuseIdentifier: acceptTableViewCell)
        
        if timer == nil {
            timerAction()
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self,
                                          selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }

    }
    
    deinit {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func timerAction() {
        self.newtworkService.getOfferSellers(parameters: [:]).done { result in
            self.products = result.result
        }
        
//        self.networkService.getChannel(parameters: ["channel_id": self.channel?.id]).done { result in
//
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func acceptAction(_ sender: Any) {
       
    }
    
    @IBAction func rejectAction(_ sender: Any) {
        
    }
    
}

//MARK: - UITableView


extension SelllerViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = products[indexPath.item]
        
        let price = product.confirmed_price_user
        
        if let priceSeller = product.confirmed_price_seller {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: acceptTableViewCell, for: indexPath) as! AcceptTableViewCell
            
            cell.nameLabel.text = product.item
            cell.costLabel.text = "\(priceSeller) rub price"
            cell.costLabel.textColor = UIColor.green
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: productAlmostReadyCell, for: indexPath) as! ProductAlmostReadyCell
        cell.backgroundColor = UIColor.white
        cell.nameLabel.text = product.item
        cell.costLabel.text = "\(price) rub price"
        
        cell.delegateAlmostReady = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let priceSeller = products[indexPath.item].confirmed_price_seller {
            return 50
        }
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension SelllerViewController: AlmostReadyDelegate {
    
    func productOKAction(cell: UITableViewCell) {
//        //guard let index = tableView.indexPath(for: cell), products.count > index.row else { return }
//        let product = products[index.row]
//
//        products[index.row].confirmed_price_seller = products[index.row].confirmed_price_user
//
//        let params = ["item_id": product.id]
//
//        startAnimating()
//
//        newtworkService.acceptOfferSellers(parameters: params).done { _ in
//            self.stopAnimating()
//            //self.products = result.result
//        }.catch { error in
//            self.products[index.row].confirmed_price_seller = nil
//            self.stopAnimating()
//            self.handleError(error: error, retry: nil)
//        }
    }
    
    
    

    func productCancelAction(cell: UITableViewCell) {
//        //guard let index = tableView.indexPath(for: cell), products.count > index.row else { return }
//        let product = products[index.row]
//
//        products[index.row].confirmed_price_seller = nil
//
//        let params = ["item_id": product.id]
//
//        startAnimating()
//
//        newtworkService.rejectOfferSellers(parameters: params).done { _ in
//            //self.products = result.result
//            self.stopAnimating()
//        }.catch { error in
//            self.stopAnimating()
//            self.handleError(error: error, retry: nil)
//        }

    }
}


