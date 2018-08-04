//
//  NetworkManager.swift
//  SimpleWebRTC
//
//  Created by Zhenya on 02.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class NetworkService {
    
    let networkManager = NetworkManager()
    
    //MARK: - Login

    func login(parameters: [String: Any]) -> Promise<Result<Token>> {
        return networkManager.request(url: "/auth/auth", parameters: parameters)
    }
    
    func confirmPhone(parameters: [String: Any])  -> Promise<Result<TempPassword>> {
        return networkManager.request(url: "/auth/register", parameters: parameters)
    }
    
    func confirmCode(parameters: [String: Any])  -> Promise<Void> {
        return networkManager.request(url: "/auth/verifyPhone", parameters: parameters)
    }
    
    func setName(parameters: [String: Any]) -> Promise<Void> {
        return networkManager.request(url: "/mrkt/changeName", parameters: parameters)
    }
    
    func setPass(parameters: [String: Any]) -> Promise<Void> {
        return networkManager.request(url: "/auth/setNewPassword", parameters: parameters)
    }
    
    //MARK: - Market
    
    func obtainMarkets(parameters: [String: Any]) -> Promise<Result<[Market]>> {
        return networkManager.request(url: "/mrkt/getMarkets", parameters: parameters)
    }
    
    
    func obtainMarketInfo(parameters: [String: Any]) -> Promise<Result<MarketInfo>> {
        return networkManager.request(url: "/mrkt/getMarket", parameters: parameters)
    }
    
    func obtainExperts(parameters: [String: Any]) -> Promise<Result<[Expert]>> {
        return networkManager.request(url: "/mrkt/getExperts", parameters: parameters)
    }
    
    //MARK: - Product
    
    func obtainProducts(parameters: [String: Any]) -> Promise<Result<[Product]>> {
        return networkManager.request(url: "/mrkt/getShoppingList", parameters: parameters)
    }
    
    func addProduct(parameters: [String: Any]) -> Promise<Result<[Product]>> {
        return networkManager.request(url: "/mrkt/addToShoppingList", parameters: parameters)
    }
    
    func deleteProduct(parameters: [String: Any]) -> Promise<Result<[Product]>> {
        return networkManager.request(url: "/mrkt/removeFromShoppingList", parameters: parameters)
    }
    
    //MARK: - Order
    
    func obtainOrder(parameters: [String: Any]) -> Promise<Result<[Order]>> {
        return networkManager.request(url: "/mrkt/getOrdersList", parameters: parameters)
    }
    
    
    
    
}

class NetworkManager  {
    
    let configuration = URLSessionConfiguration.default
    let afManager : SessionManager!
    let decoder = JSONDecoder()
    
    init() {
        afManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func prettyPrint(with json: [String: Any]) -> String {
        // swiftlint:disable force_try
        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        // swiftlint:enable force_try
        // swiftlint:disable force_cast
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        return string as! String
        // swiftlint:enable force_cast
    }
    
    
    func request<T: Codable>(url: String, parameters: [String: Any]) ->  Promise<T> {
        let URL = baseURL + url
        var params = parameters
        
        if let token = Storage.shared.getToken() {
            params["token"] = token
        }
        
        return Promise { resolver in
            
            afManager.request(URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
                
                switch response.result {
                case .success:

                    guard let jsonValue = response.result.value, let data = try? JSONSerialization.data(withJSONObject: jsonValue)  else {
                        return resolver.reject(NetworkError.error)
                    }
                    
                    do {
                        let model: T = try self.decoder.decode(T.self, from: data)
                        resolver.fulfill(model)
                        return
                    } catch { error
                        print(error)
                        if let backendError: BackendError = try? self.decoder.decode(BackendError.self, from: data) {
                            resolver.reject(NetworkError.message(backendError.error.message))
                            return
                        }
                    }
        
                    resolver.reject(NetworkError.error)
                    
                    break
                case .failure(let error):
                    print("error - > \n    \(error.localizedDescription) \n")
                    resolver.reject(error)
                    break
                }
                
            }
        }
        
    }
    
    
    func request(url: String, parameters: [String: Any]) ->  Promise<Void> {
        let URL = baseURL + url
        var params = parameters
        
        if let token = Storage.shared.getToken() {
            params["token"] = token
        }
        
        
        return Promise { resolver in
            
            afManager.request(URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
                
                switch response.result {
                case .success:
                    
                    guard let jsonValue = response.result.value, let data = try? JSONSerialization.data(withJSONObject: jsonValue)  else {
                        return resolver.reject(NetworkError.error)
                    }
                    
                    if let backendError: BackendError = try? self.decoder.decode(BackendError.self, from: data) {
                        resolver.reject(NetworkError.message(backendError.error.message))
                        return
                    }
                
                    resolver.fulfill(())

                    break
                case .failure(let error):
                    print("error - > \n    \(error.localizedDescription) \n")
                    resolver.reject(error)
                    break
                }
                
            }
        }
        
    }
}


