//
//  ExpertSetPriceViewController.swift
//  SimpleWebRTC
//
//  Created by Evgen on 07.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import UIKit

class ExpertSetPriceViewController: BaseViewController {
    
    var channelId: Int = 0
    var product: Product!
    var parameters: [String: Any] = [:]
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var sellerId: UITextField!
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
    @IBAction func doneAction(_ sender: Any) {
        guard let price = priceTextField.text, let id = sellerId.text,
            let priceInt = Int(price), let idInt = Int(id) else { return }

        parameters = ["channel_id":channelId, "item_id": product.id, "seller_id": idInt, "offered_price": priceInt]
        confirm()
    }
    
    private func confirm() {
        networkService.offerPriceExpert(parameters: parameters).done {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }.catch { error in
            self.handleError(error: error, retry: self.confirm)
        }
    }
    
}
