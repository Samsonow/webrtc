//
//  ExpertWebRTCViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 06.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//
//ExpertWebRTCViewController
import UIKit

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


class ExpertWebRTCViewController: BaseViewController {
    //TODO: refact
    var addParemetrs: [String: Any] = [:]
    var parametersdell: [String: Any] = [:]
    var timer: Timer?
    var channelId: Int!
    var channel: ChannelGet?
    
    var selectIndex: Int = 0
    
    
    private var products: [Product] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        evo_drawerController?.screenEdgePanGestureEnabled = false
        //self.evo_drawerController?.openDrawerGestureModeMask = .panningNavigationBar
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        
        remoteVideoView.delegate = self
        localVideoView.delegate = self

        let roomName = "MAIN_ROOM"
        let client = WebRtcClient.shared
    
        client.listener = self
        client.start(roomName: roomName)
        
        setup()
        obtainData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.isNavigationBarHidden = true
    }
    
 
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
     
    }
    
    @IBAction func addProductAction(_ sender: Any) {
       
        if let item = productTextField.text {
            addProduct(item: item)
        }
        productTextField.text = ""
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

    }
    
    @objc func updateData() {
        network.obtainProductsExpert(parameters: ["channel_id": self.channelId]).done { result in
            self.handelGetProduct(result.result)
        }
        
        network.getChannelExpert(parameters: ["channel_id": self.channelId]).done { result in
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
            self.performSegue(withIdentifier: "delivery", sender: nil)
            
            
        case .COMPLETED:
            print("COMPLETED")
            
        case .REFUSED:
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
            self.performSegue(withIdentifier: "error", sender: nil)
            print("REFUSED")
            

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
        addParemetrs = ["channel_id": channelId, "item":item]
        requstAddProduct()
    }
    
    func requstAddProduct() {
        network.addItemExpert(parameters: addParemetrs).done { result in
            self.handelGetProduct(result.result)
            self.stopAnimating()
        }.catch { error in
            self.stopAnimating()
            self.handleError(error: error, retry: self.requstAddProduct)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "setPrice" {
            var vc = segue.destination as! ExpertSetPriceViewController
            vc.channelId = channelId
            vc.product = products[selectIndex]
        }
        
        if segue.identifier == "delivery" {
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
            var vc = segue.destination as! ExpertDeliveryViewController
            vc.channelId = channelId
        }
        
        
    }
    
}

extension ExpertWebRTCViewController: RTCEAGLVideoViewDelegate {
    
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

extension ExpertWebRTCViewController: RtcListener {
    
    func localStreamAdded(_ stream: RTCMediaStream) {
        self.localVideoStream = stream
    }
    
    func remoteStreamAdded(_ stream: RTCMediaStream) {
        self.remoteVideoStream = stream
    }
    
}


//MARK: - UITableView
extension ExpertWebRTCViewController: UITableViewDelegate, UITableViewDataSource {
    
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: acceptTableViewCell, for: indexPath) as! AcceptTableViewCell
            cell.nameLabel.text = product.item
            cell.costLabel.text = "\(price) rub price"
  
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellId, for: indexPath) as! ProductCell
        cell.titleLabel.text = products[indexPath.item].item
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let product = products[indexPath.item]

        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "setPrice", sender: nil)
        selectIndex = indexPath.row
    }

}

extension ExpertWebRTCViewController: SwipeTableViewCellDelegate {
    
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
        parametersdell = ["channel_id": channelId, "id": id]
        dellRequst()
    }
    
    func dellRequst() {
        network.deleteProductExpert(parameters: parametersdell).done { result in
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


extension ExpertWebRTCViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let item = productTextField.text {
            addProduct(item: item)
        }
        productTextField.text = ""
        return true
    }
}








