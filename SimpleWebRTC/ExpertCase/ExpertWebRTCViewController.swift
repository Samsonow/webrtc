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


class ExpertWebRTCViewController: BaseViewController, AddProductPopVCDelegate {

    //TODO: refact
    var addParemetrs: [String: Any] = [:]
    var parametersdell: [String: Any] = [:]
    var timer: Timer?
    var channelId: Int!
    var channel: ChannelGet?
    
    var selectIndex: Int = 0
    
    weak var delegate: AddProductPopVC?
    var addProductView: AddProductView?
    var viewFon: UIView?
    
    
    var products: [Product] = [] {
        didSet {
            delegate?.products = products
        }
    }
    

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
        
        obtainData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.isNavigationBarHidden = true
        
        if delegate == nil {
            addBottomSheetView()
        }
        
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

    
    func handelGetProduct(_ product: [Product]) {
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ExpertMainViewController")
            let nav = UINavigationController(rootViewController: controller)
            evo_drawerController?.mainViewController = nav
            evo_drawerController?.setDrawerState(.closed, animated: true)
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ExpertMainViewController")
        let nav = UINavigationController(rootViewController: controller)
        evo_drawerController?.mainViewController = nav
        //performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
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
            WebRtcClient.shared.leave()
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


//extension ExpertWebRTCViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        
//        if let item = productTextField.text {
//            addProduct(item: item)
//        }
//        productTextField.text = ""
//        return true
//    }
//}


extension ExpertWebRTCViewController: AddProductDelegate {
    
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
    
    func didSelectRowAt(index :Int) {
        self.performSegue(withIdentifier: "setPrice", sender: nil)
        selectIndex = index
    }
    
}
