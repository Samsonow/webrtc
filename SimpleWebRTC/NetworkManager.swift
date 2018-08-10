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
import AlamofireLogger

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
    
    //MARK: - Order Address
    //was Address
    func setAddress(parameters: [String: Any]) -> Promise<Result<Address>> {
        return networkManager.request(url: "/mrkt/changeAddress", parameters: parameters)
    }
    
    //MARK: - User
    
    func obtainUser(parameters: [String: Any]) -> Promise<Result<User>> {
        return networkManager.request(url: "/mrkt/getUser", parameters: parameters)
    }
    
    //MARK: - Channel
    
    func obtainChannel(parameters: [String: Any]) -> Promise<Result<Channel>> {
        return networkManager.request(url: "/mrkt/requestChannel", parameters: parameters)
    }
    
    func getChannelsClient(parameters: [String: Any]) -> Promise<Result<[ChannelGet]>>  {
        return networkManager.request(url: "/mrkt/getChannels", parameters: parameters)
    }
    
    func getChannel(parameters: [String: Any]) -> Promise<Result<ChannelGet>> {
        return networkManager.request(url: "/mrkt/getChannel", parameters: parameters)
    }
    
    func cancelChannel(parameters: [String: Any]) -> Promise<Void> {
        return networkManager.request(url: "/mrkt/cancelChannel", parameters: parameters)
    }
    
    //MARK: - Products
    
    func acceptPrice(parameters: [String: Any]) -> Promise<Void> {
        return networkManager.request(url: "/mrkt/acceptPrice", parameters: parameters)
    }
    
    func rejectPrice(parameters: [String: Any]) -> Promise<Void> {
        return networkManager.request(url: "/mrkt/rejectPrice", parameters: parameters)
    }
    
    //Delivery
    
    func startDelivery(parameters: [String: Any]) -> Promise<Void> {
        return networkManager.request(url: "/mrkt/startDelivery", parameters: parameters)
    }
    
    func completeChannel(parameters: [String: Any]) -> Promise<Void>  {
        return networkManager.request(url: "/mrkt/completeChannel", parameters: parameters)
    }
    
    
    //EXPERT CASE
    func setAvailability(parameters: [String: Any]) -> Promise<Void>  {
        return networkManager.request(url: "/mrkt/experts/setAvailability", parameters: parameters)
    }
    
    func setMarket(parameters: [String: Any]) -> Promise<Void>  {
        return networkManager.request(url: "/mrkt/experts/setMarket", parameters: parameters)
    }
    
    func getChannels(parameters: [String: Any]) -> Promise<Result<[ChannelGet]>>  {
        return networkManager.request(url: "/mrkt/experts/getChannels", parameters: parameters)
    }
    
    func rejectChannel(parameters: [String: Any]) -> Promise<Void>  {
        return networkManager.request(url: "/mrkt/experts/rejectChannel", parameters: parameters)
    }
    
    func acceptChannel(parameters: [String: Any]) -> Promise<Void>  {
        return networkManager.request(url: "/mrkt/experts/acceptChannel", parameters: parameters)
    }
    
    func obtainProductsExpert(parameters: [String: Any]) -> Promise<Result<[Product]>> {
        return networkManager.request(url: "/mrkt/experts/getChannelShoppingList", parameters: parameters)
    }
    
    func getChannelExpert(parameters: [String: Any]) -> Promise<Result<ChannelGet>> {
        return networkManager.request(url: "/mrkt/experts/getChannel", parameters: parameters)
    }
    
    func addItemExpert(parameters: [String: Any]) -> Promise<Result<[Product]>> {
        return networkManager.request(url: "/mrkt/experts/addItem", parameters: parameters)
    }
    
    func deleteProductExpert(parameters: [String: Any]) -> Promise<Result<[Product]>> {
        return networkManager.request(url: "/mrkt/experts/removeItem", parameters: parameters)
    }
    
    func offerPriceExpert(parameters: [String: Any]) -> Promise<Void> {
        return networkManager.request(url: "/mrkt/experts/offerPrice", parameters: parameters)
    }
    
    func setPositionExpert(parameters: [String: Any]) -> Promise<Void> {
        return networkManager.request(url: "/mrkt/experts/setPosition", parameters: parameters)
    }
    
    //Seller
    
    
    func getOfferSellers(parameters: [String: Any]) -> Promise<Result<[SellerProduct]>> {
        return networkManager.request(url: "/mrkt/sellers/getOffers", parameters: parameters)
    }
    //Result<[SellerProduct]>
    func acceptOfferSellers(parameters: [String: Any]) -> Promise<Void> {
        return networkManager.request(url: "/mrkt/sellers/acceptOffer", parameters: parameters)
    }
    
    func rejectOfferSellers(parameters: [String: Any]) -> Promise<Void> {
        return networkManager.request(url: "/mrkt/sellers/rejectOffer", parameters: parameters)
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
            
            
            afManager.requestWithoutCache(URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).log(.verbose).validate().responseJSON { response in
                
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



