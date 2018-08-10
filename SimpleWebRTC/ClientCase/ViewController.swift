//
//  ViewController.swift
//  SimpleWebRTC
//
//  Created by Erdi T on 21.01.2018.
//  Copyright © 2018 Mirana Software. All rights reserved.
//

import UIKit
import WebRTC
import SwipeCellKit
import KYDrawerController


class ViewController: BaseViewController {
    //TODO: refact
    var addParemetrs: [String: Any] = [:]
    var parametersdell: [String: Any] = [:]
    var timer: Timer?
    var channelId: Int = 0
    var channel: ChannelGet?
    
    @IBOutlet weak var hightButton: NSLayoutConstraint!
    
    private var products: [Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var startDelivery: UIButton!
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    private let productCellId: String = "ProductCell"
    private let productAlmostReadyCell: String = "ProductAlmostReadyCell"
    private let acceptTableViewCell: String = "AcceptTableViewCell"

    
    var remoteVideoStream: RTCMediaStream? {
        didSet {
            self.remoteVideoStream?.videoTracks[0].add(self.remoteVideoView)
        }
    }
    
    let network = NetworkService()
    
    var localVideoStream: RTCMediaStream? {
        didSet {
            self.localVideoStream?.videoTracks[0].add(self.localVideoView)
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var remoteVideoView: RTCEAGLVideoView!
    @IBOutlet weak var localVideoView: RTCEAGLVideoView!
    
    @IBOutlet weak var remoteVideoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var localVideoHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        hightButton.constant = 0
        
        evo_drawerController?.screenEdgePanGestureEnabled = false
        //self.evo_drawerController?.openDrawerGestureModeMask = .panningNavigationBar
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
   
        
        remoteVideoView.delegate = self
        localVideoView.delegate = self
        
        localVideoView.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        let roomName = "MAIN_ROOM"
        let client = WebRtcClient.shared
        client.listener = self
        client.start(roomName: roomName)
        
        setup()
        obtainData()

    }
    
    @IBAction func addProductAction(_ sender: Any) {
        if let item = productTextField.text {
            addProduct(item: item)
        }
    }
    
    @IBAction func stratAction(_ sender: Any) {
        network.startDelivery(parameters: ["channel_id":channelId]).done {
            self.performSegue(withIdentifier: "startDelevery", sender: nil)
        }
    }
    
    private func setup() {
        
        let nibProduct = UINib(nibName: productCellId, bundle: nil)
        tableView.register(nibProduct, forCellReuseIdentifier: productCellId)
        
        let productAlmost = UINib(nibName: productAlmostReadyCell, bundle: nil) 
        tableView.register(productAlmost, forCellReuseIdentifier: productAlmostReadyCell)
        
        let acceptNib = UINib(nibName: acceptTableViewCell, bundle: nil)
        tableView.register(acceptNib, forCellReuseIdentifier: acceptTableViewCell)

        tableView.tableFooterView = UIView()
    }
    
    private func handelGetProduct(_ product: [Product]) {
        var resultTest = product
        resultTest.reverse()
        self.products = resultTest
        
        let product = resultTest.first(where: { $0.confirmed_price_seller == nil })
        if product != nil || resultTest.isEmpty {
            hightButton.constant = 0
            //self.startDelivery.isHidden = true
        } else {
            hightButton.constant = 67
            //self.startDelivery.isHidden = false
        }
    }
    
    @objc func updateData() {
        network.obtainProducts(parameters: [:]).done { result in
            self.handelGetProduct(result.result)
        }
    
        network.getChannel(parameters: ["channel_id": self.channelId]).done { result in
            self.channel = result.result
            self.handelChangeChannel(chanel: result.result)
        }
    }
    
    private func handelChangeChannel(chanel: ChannelGet ) {
        switch chanel.state {
            
        case .REQUESTED:
            
            print("REQUESTED")
            
        case .REJECTED:
     
            print("REJECTED")
            
        case .CANCELLED:
            //я отменил
            print("CANCELLED")
            
        case .OPENED:
            print("OPENED")
            
        case .DELIVERY:
            print("DELIVERY")
            
        case .COMPLETED:
            print("COMPLETED")
            
        case .REFUSED:
       
            self.performSegue(withIdentifier: "error", sender: nil)
            print("REFUSED")
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
            
            
            
   
        case .ARCHIVED:
            print("ARCHIVED")
            
        }
    }
    
    @objc func back() {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }

    
    
    
    func obtainData() {
        if timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                          selector: #selector(self.updateData), userInfo: nil, repeats: true)
        }
        network.obtainProducts(parameters: [:]).done { result in
           self.handelGetProduct(result.result)
        }.catch { error in
            self.handleError(error: error, retry: self.obtainData)
        }
        
    }
    
    private func addProduct(item: String) {
        startAnimating()
        addParemetrs = ["item":item]
        requstAddProduct()
    }
    
    func requstAddProduct() {
        network.addProduct(parameters: addParemetrs).done { result in
            self.view.endEditing(true)
            self.productTextField.text = ""
            self.handelGetProduct(result.result)
            self.stopAnimating()
        }.catch { error in
            self.stopAnimating()
            self.handleError(error: error, retry: self.requstAddProduct)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "createUser" , let data = sender as? [String: Any] {
            var vc = segue.destination as! RegistrationViewController
            vc.currentPassword = data["pass"] as! String
        }
        
        if segue.identifier == "startDelevery" {
            var vc = segue.destination as! MapClientViewController
            guard let channel = channel else { return }
            vc.channel = channel
        }
    }

}

extension ViewController: RTCEAGLVideoViewDelegate {
    
    func videoView(_ videoView: RTCEAGLVideoView, didChangeVideoSize size: CGSize) {
        let scale = size.width / size.height
        switch videoView {
        case remoteVideoView:
            let height = videoView.frame.width / scale
            remoteVideoHeightConstraint.constant = height
            videoView.layoutIfNeeded()
        case localVideoView:
            let height = videoView.frame.width / scale
            localVideoHeightConstraint.constant = height
            videoView.layoutIfNeeded()
        default:
            break
        }
    }
    
}

extension ViewController: RtcListener {
    
    func localStreamAdded(_ stream: RTCMediaStream) {
        self.localVideoStream = stream
    }
    
    func remoteStreamAdded(_ stream: RTCMediaStream) {
        self.remoteVideoStream = stream
    }
    
}


//MARK: - UITableView


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = products[indexPath.item]
        
        if let offeredPrice = product.offered_price,
            let userPrice = product.confirmed_price_user,
            let sellerPrice = product.confirmed_price_seller  {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: acceptTableViewCell, for: indexPath) as! AcceptTableViewCell
        
            cell.nameLabel.text = product.item
            cell.costLabel.text = "\(sellerPrice) rub price"
            cell.costLabel.textColor = UIColor.green
            return cell
        }
        
        
        
        if let offeredPrice = product.offered_price, let userPrice = product.confirmed_price_user  {
            let cell = tableView.dequeueReusableCell(withIdentifier: acceptTableViewCell, for: indexPath) as! AcceptTableViewCell
            cell.nameLabel.text = product.item
            cell.costLabel.text = "\(offeredPrice) rub price"
            cell.costLabel.textColor = UIColor.blue
            return cell
        }
        
        if let price = product.offered_price {
            let cell = tableView.dequeueReusableCell(withIdentifier: productAlmostReadyCell, for: indexPath) as! ProductAlmostReadyCell
            cell.nameLabel.text = product.item
            cell.costLabel.text = "\(price) rub price"
            
            cell.delegateAlmostReady = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellId, for: indexPath) as! ProductCell
        cell.titleLabel.text = products[indexPath.item].item
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let product = products[indexPath.item]
        if let offeredPrice = product.offered_price,
            let userPrice = product.confirmed_price_user,
            let sellerPrice = product.confirmed_price_seller  {
            
            return 50
        }
        
        if let offeredPrice = product.offered_price, let userPrice = product.confirmed_price_user  {
  
            return 50
        }
        
        if let price = product.offered_price {

            return 140
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}

extension ViewController: SwipeTableViewCellDelegate {
    
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
            self.handelGetProduct(result.result)
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

extension ViewController: AlmostReadyDelegate {
    
    func productOKAction(cell: UITableViewCell) {
        guard let index = tableView.indexPath(for: cell), products.count > index.row else { return }
        
        startAnimating()
        
        network.acceptPrice(parameters: ["item_id": products[index.row].id]).done {
            self.stopAnimating()
            self.products[index.row].confirmed_price_user = self.products[index.row].offered_price
        }.catch { error in
            self.stopAnimating()
            self.handleError(error: error, retry: nil)
        }
    }
    
    
    func productCancelAction(cell: UITableViewCell) {
        guard let index = tableView.indexPath(for: cell), products.count > index.row else { return }
        
        startAnimating()
        
        network.rejectPrice(parameters: ["item_id": products[index.row].id]).done {
            self.stopAnimating()
            self.products[index.row].offered_price = nil
        }.catch { error in
            self.stopAnimating()
            self.handleError(error: error, retry: nil)
        }
    }
}


