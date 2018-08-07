//
//  ExpertChooseViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 06.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class ExpertChooseViewController: BaseViewController {
    
    let networkService = NetworkService()
    
    var channelId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
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
