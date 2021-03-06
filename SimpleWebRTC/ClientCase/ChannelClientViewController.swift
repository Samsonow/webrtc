//
//  ChannelClientViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 05.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import PromiseKit
import NVActivityIndicatorView
import KYDrawerController

class ChannelClientViewController: BaseViewController {
    
    var expertId: Int!
    let networkService = NetworkService()
    var channel: ChannelGet?
    
    @IBOutlet weak var infoLabel: UILabel!
    var indicatorView: NVActivityIndicatorView!
    
    var timer: Timer?

    override func viewDidLoad() {

        self.navigationController?.isNavigationBarHidden = true
        
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        indicatorView = NVActivityIndicatorView(frame: frame, type: .lineScale, color: UIColor.red, padding: nil)
        self.view.addSubview(indicatorView)
        
        indicatorView.center = self.view.convert(self.view.center, from:self.view.superview)
        
        indicatorView.startAnimating()
        
        super.viewDidLoad()
        obtainData()
    }
    
    deinit {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    

    
    func obtainData() {
        
        if let channel = self.channel {
            if timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                              selector: #selector(self.timerAction), userInfo: nil, repeats: true)
            }
            return
        }
        
        let params: [String: Any] = ["expert_id": expertId]
        networkService.obtainChannel(parameters: params).done { result in
            let chanel = result.result
           
            self.channel = ChannelGet(form: chanel)
    
        }.done {
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                              selector: #selector(self.timerAction), userInfo: nil, repeats: true)
            }
        }.catch { error in
            self.handleError(error: error, retry: self.obtainData)
            
           
        }
    }
    
    @objc func timerAction() {
        self.networkService.getChannel(parameters: ["channel_id": self.channel?.id]).done { result in
            self.channel = result.result
            self.handelChangeChannel(chanel: result.result)
        }
    }
    
    private func handelChangeChannel(chanel: ChannelGet) {
        switch chanel.state {
            
        case .REQUESTED:
            print("REQUESTED")
            
        case .REJECTED:
            infoLabel.isHidden = false
            infoLabel.text = "Expert rejected"
            indicatorView.stopAnimating()
            print("REJECTED")
            
        case .CANCELLED:
            
            //ЕЩВЩ
            print("CANCELLED")
            
        case .OPENED:
            print("OPENED")
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
            
            self.performSegue(withIdentifier: "webrtc", sender: nil)

        case .DELIVERY:
            print("DELIVERY")
            
        case .COMPLETED:
            print("COMPLETED")
            
        case .REFUSED:
            print("REFUSED")
            
        case .ARCHIVED:
            print("ARCHIVED")
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func cancelAction(_ sender: Any) {
       // guard let id = channel?.id  else { return }
        
        if channel?.state == .REJECTED {
            self.goToMarkets()
            return
        }
        
        let parameters: [String: Any] = ["channel_id": channel?.id]
        networkService.cancelChannel(parameters: parameters).always {
            self.goToMarkets()
        }
        
    }
    
    private func goToMarkets() {
        guard let drawerController = navigationController?.parent as? KYDrawerController else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MarketsViewController")
        let nav = UINavigationController(rootViewController: controller)
        
        //drawerController.performSegue(withIdentifier: "main", sender: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // change 2 to desired number of seconds
            drawerController.mainViewController = nav
            drawerController.setDrawerState(.closed, animated: true)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "webrtc" {
            var vc = segue.destination as! ViewController
            vc.channelId = channel?.id ?? -1
        }
    }

}
