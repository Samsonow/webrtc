//
//  ExpertViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 05.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class ExpertMainViewController: BaseViewController {

    let networkService = NetworkService()
    var timer = Timer()
    
    let available = "You are available for requests"
    let availableButton = "PAUSE"
    
    var firstChannel: ChannelGet! {
        didSet {
            performSegue(withIdentifier: "accept", sender: nil)
        }
    }
    
    let unavailable = "You are unavailable at the moment"
    let unavailableButton = "MAKE ME AVAILABLE"
    
    var isAvailable: Bool = true {
        didSet {
            if isAvailable {
                infoLabel.textColor = UIColor.green
                infoLabel.text = available
                buttonAvailable.setTitle(availableButton, for: .normal)
            } else {
                infoLabel.textColor = UIColor.red
                infoLabel.text = unavailable
                buttonAvailable.setTitle(unavailableButton, for: .normal)
            }
        }
    }
    
    
    @IBOutlet weak var buttonAvailable: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupLeftMenuButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                          selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    

    deinit {
        timer.invalidate()
    }
    
    @objc func timerAction() {
        self.networkService.getChannels(parameters: [:]).done { result in
            if !result.result.isEmpty, let first = result.result.first  {
                self.firstChannel = first
            }
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
            
        case .OPENED:
            print("OPENED")
            timer.invalidate()
            
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
    
    @IBAction func actionPause(_ sender: Any) {
        setAvailability()
    }
    
    private func setAvailability() {
        let params: [String: Any] = ["available": !isAvailable]
        networkService.setAvailability(parameters: params).done {
            self.isAvailable = !self.isAvailable
        }.catch { error in
            self.handleError(error: error, retry: self.setAvailability)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        timer.invalidate()
        
        if segue.identifier == "accept" {
            var vc = segue.destination as! ExpertChooseViewController
            vc.channelId = firstChannel.id
        }
    }
    
}
