//
//  ExpertChooseViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 06.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ExpertChooseViewController: BaseViewController {
    
    var indicatorView: NVActivityIndicatorView!
    let networkService = NetworkService()
    let network = NetworkService()
    var channelId: Int = 0
    
    var timer: Timer?
    
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        
        let colorTop =  UIColor(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        indicatorView = NVActivityIndicatorView(frame: frame, type: .ballSpinFadeLoader, color: UIColor.white, padding: nil)
        self.view.addSubview(indicatorView)
        
        indicatorView.center = self.view.convert(self.view.center, from:self.view.superview)
        
        indicatorView.startAnimating()
        
        UIApplication.shared.statusBarStyle = .lightContent

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                              selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerAction() {
        
        network.getChannelExpert(parameters: ["channel_id": self.channelId]).done { result in
            self.handelChangeChannel(chanel: result.result)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
    }
    
    
    private func handelChangeChannel(chanel: ChannelGet) {
        switch chanel.state {
            
        case .REQUESTED:
            print("REQUESTED")
            
        case .REJECTED:
            
            print("REJECTED")
            
        case .CANCELLED:
            print("CANCELLED")
            
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            
            
        case .OPENED:
            print("OPENED")
            
            
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
    

    @IBAction func aceptAction(_ sender: Any) {
        acept()
    }
    
    private func acept() {
        let parameters: [String: Any] = ["channel_id": channelId]
        networkService.acceptChannel(parameters: parameters).done {
            self.performSegue(withIdentifier: "webrtc", sender: nil)
        }.catch { error in
            self.handleError(error: error, retry: self.acept)
        }
    }
    
    @IBAction func rejectAction(_ sender: Any) {
        reject()
    }
    
    private func reject() {
        let parameters: [String: Any] = ["channel_id": channelId]
        networkService.rejectChannel(parameters: parameters).done {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }.catch { error in
            self.handleError(error: error, retry: self.acept)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    
        if segue.identifier == "webrtc" {
            var vc = segue.destination as! ExpertWebRTCViewController
            vc.channelId = channelId
        }
    }
    
}
