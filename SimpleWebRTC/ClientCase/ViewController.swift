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
import IQKeyboardManager


class ViewController: BaseViewController, AddProductPopVCDelegate {
    
    //TODO: refact
    var addParemetrs: [String: Any] = [:]
    var parametersdell: [String: Any] = [:]
    var refuseParameters: [String: Any] = [:]
    var timer: Timer?
    var channelId: Int = 0
    var channel: ChannelGet?
    
    
    weak var delegate: AddProductPopVC?
    var addProductView: AddProductView?
    var viewFon: UIView?
    
    let network = NetworkService()
    
    @IBOutlet weak var endBoughtButton: UIButton!
    @IBOutlet weak var remouteWight: NSLayoutConstraint!
    @IBOutlet weak var hightButton: NSLayoutConstraint!
    
    var products: [Product] = [] {
        didSet {
            delegate?.products = products
        }
    }
    
    @IBOutlet weak var startDelivery: UIButton!

    var remoteVideoStream: RTCMediaStream? {
        didSet {
            self.remoteVideoStream?.videoTracks[0].add(self.remoteVideoView)
        }
    }

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
    
    @IBAction func cancelCall(_ sender: Any) {
        refuseChanne()
    }
    
    private func refuseChanne() {
        
        let params = ["channel_id":channelId]
        
        startAnimating()
        
        network.refuseChannelClient(parameters: params).done {
            
            self.stopAnimating()
            WebRtcClient.shared.leave()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MarketsViewController")
            let nav = UINavigationController(rootViewController: controller)
            evo_drawerController?.mainViewController = nav
            evo_drawerController?.setDrawerState(.opened, animated: false)
            evo_drawerController?.setDrawerState(.closed, animated: false)
            
        }.catch { error in
            
            self.stopAnimating()
            self.handleError(error: error, retry: self.refuseChanne)
        }
    }
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        self.startDelivery.isHidden = true
        hightButton.constant = 0
        
        evo_drawerController?.screenEdgePanGestureEnabled = false
        //self.evo_drawerController?.openDrawerGestureModeMask = .panningNavigationBar
        self.navigationController?.isNavigationBarHidden = true
   
        
        remoteVideoView.delegate = self
        localVideoView.delegate = self
        
        localVideoView.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        let roomName = "MAIN_ROOM"
        let client = WebRtcClient.shared
        client.listener = self
        client.start(roomName: roomName)

        obtainData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        if delegate == nil {
           addBottomSheetView()
            self.view.bringSubview(toFront: endBoughtButton)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
    }
    
    private func addBottomSheetView() {
     
        let storyboard = UIStoryboard(name: "AddProduct", bundle: nil)
        let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "AddProductPopVC")
        
        let height = UIScreen.main.bounds.height
        let width  = UIScreen.main.bounds.width
        
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        
        bottomSheetVC.view.layer.cornerRadius = 10
        bottomSheetVC.view.clipsToBounds = true
        
        self.view.addSubview(bottomSheetVC.view)
        self.addChildViewController(bottomSheetVC)
        bottomSheetVC.didMove(toParentViewController: self)
        
        let addProductPopVC = bottomSheetVC as! AddProductPopVC
        
        addProductPopVC.delegate = self
        delegate = addProductPopVC

    }
    
    func addProductAction() {
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
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        self.addProductView?.removeFromSuperview()
        self.viewFon?.removeFromSuperview()
        self.view.endEditing(true)
        
        addProductView = nil
        viewFon = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    
    @IBAction func stratAction(_ sender: Any) {
        network.startDelivery(parameters: ["channel_id" : channelId]).done {
            self.performSegue(withIdentifier: "startDelevery", sender: nil)
        }
    }
    
    //TODO: products
    func handelGetProduct(_ product: [Product]) {
    
        var resultTest = product
        resultTest.reverse()
        self.products = resultTest
        
        products.forEach({ (product) in
            let type = product.getType()
            if case .confirmExpert = type {
                self.showConfirm(with: product.offered_price ?? 0, id: product.id )
            }
        })
        
        let product = resultTest.first(where: { $0.confirmed_price_seller == nil })
        if product != nil || resultTest.isEmpty {
            hightButton.constant = 0
            self.startDelivery.isHidden = true
        } else {
            hightButton.constant = 67
            self.startDelivery.isHidden = false
        }
    }
    
    @objc func updateData() {
        network.obtainProducts(parameters: [:]).done { result in
            let products = result.result
            
            self.handelGetProduct(result.result)
        }
    
        network.getChannel(parameters: ["channel_id": self.channelId]).done { result in
            self.channel = result.result
            self.handelChangeChannel(chanel: result.result)
        }
    }
    
    private func showConfirm(with price: Float, id: Int) {
        
        let alert = UIAlertController(title: "Предлагаемая цена", message: "\(price) руб", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
            self.startAnimating()
    
            self.network.acceptPrice(parameters: ["item_id": id]).done {
                
                self.stopAnimating()
                if let index = self.products.index(where: { $0.id == id}) {
                    self.products[index].confirmed_price_user = self.products[index].offered_price
                }
                
            }.catch { error in
                self.stopAnimating()
                self.handleError(error: error, retry: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { action in
            self.startAnimating()
    
            self.network.rejectPrice(parameters: ["item_id": id]).done {
                
                self.stopAnimating()
                if let index = self.products.index(where: { $0.id == id}) {
                    self.products[index].offered_price = nil
                }
                
            }.catch { error in
                self.stopAnimating()
                self.handleError(error: error, retry: nil)
            }
        }))

        present(alert, animated: true, completion: nil)
        
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
            updateData()
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
        
        if item.isEmpty {
            show(message: "Поле не должно быть пустым", retry: nil)
            return
        }
        
        startAnimating()
        addParemetrs = ["item":item]
        requstAddProduct()
    }
    
    func requstAddProduct() {
        network.addProduct(parameters: addParemetrs).done { result in
            self.view.endEditing(true)
            //self.productTextField.text = ""
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
        WebRtcClient.shared.leave()
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
           // let height = videoView.frame.width / scale
            let wight = videoView.frame.height * scale
//            let x = videoView.frame.origin.x
//            let y = videoView.frame.origin.y
            remouteWight.constant = wight
            ///remoteVideoHeightConstraint.constant = height
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

extension ViewController: AddProductDelegate {
    
    func addNewProduct(title: String) {
        addProduct(item: title)

        self.addProductView?.removeFromSuperview()
        self.viewFon?.removeFromSuperview()
        self.view.endEditing(true)
        
        addProductView = nil
        viewFon = nil
    }
    
    
    func dellProduct(with id: Int) {

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

}




//extension ViewController: AlmostReadyDelegate {
//
//    func productOKAction(cell: UITableViewCell) {
//        guard let index = tableView.indexPath(for: cell), products.count > index.row else { return }
//
//        startAnimating()
//
//        network.acceptPrice(parameters: ["item_id": products[index.row].id]).done {
//            self.stopAnimating()
//            self.products[index.row].confirmed_price_user = self.products[index.row].offered_price
//        }.catch { error in
//            self.stopAnimating()
//            self.handleError(error: error, retry: nil)
//        }
//    }
//
//
//    func productCancelAction(cell: UITableViewCell) {
//        guard let index = tableView.indexPath(for: cell), products.count > index.row else { return }
//
//        startAnimating()
//
//        network.rejectPrice(parameters: ["item_id": products[index.row].id]).done {
//            self.stopAnimating()
//            self.products[index.row].offered_price = nil
//        }.catch { error in
//            self.stopAnimating()
//            self.handleError(error: error, retry: nil)
//        }
//    }
//}


