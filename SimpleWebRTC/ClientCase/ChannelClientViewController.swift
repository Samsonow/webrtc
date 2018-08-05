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
import DrawerController

class ChannelClientViewController: BaseViewController {
    
    var expertId: Int!
    let networkService = NetworkService()
    var channel: Channel?
    
    @IBOutlet weak var infoLabel: UILabel!
    var indicatorView: NVActivityIndicatorView!
    
    var timer = Timer()

    override func viewDidLoad() {
        
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        indicatorView = NVActivityIndicatorView(frame: frame, type: .lineScale, color: UIColor.red, padding: nil)
        self.view.addSubview(indicatorView)
        
        indicatorView.center = self.view.convert(self.view.center, from:self.view.superview)
        
        indicatorView.startAnimating()
        
        super.viewDidLoad()
        obtainData()
    }
    
    deinit {
        timer.invalidate()
    }
    

    
    func obtainData() {
        
        let params: [String: Any] = ["expert_id": expertId]
        networkService.obtainChannel(parameters: params).done { result in
            self.channel = result.result
        }.done {
            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                              selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }.catch { error in
            self.handleError(error: error, retry: self.obtainData)
        }
    }
    
    @objc func timerAction() {
        self.networkService.getChannel(parameters: ["channel_id": self.channel?.id]).done { result in
            self.handelChangeChannel(chanel: result.result)
        }
    }
    
    private func handelChangeChannel(chanel: Channel ) {
        switch chanel.state {
            
        case .REQUESTED:
            print("REQUESTED")
            
        case .REJECTED:
            infoLabel.isHidden = false
            infoLabel.text = "Expert rejected"
            indicatorView.stopAnimating()
            print("REJECTED")
            
        case .CANCELLED:
            print("CANCELLED")
            
        case .OPENED:
            print("OPENED")
            self.performSegue(withIdentifier: "webrtc", sender: nil)

        case .DELIVERY:
            print("DELIVERY")
            
        case .COMPLETED:
            print("COMPLETED")
            
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
        networkService.cancelChannel(parameters: parameters).done {
            self.goToMarkets()
        }
    }
    
    private func goToMarkets() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MarketsViewController")
        let nav = UINavigationController(rootViewController: controller)
        self.evo_drawerController?.setCenter(nav, withCloseAnimation: true, completion: nil)
    }

}
