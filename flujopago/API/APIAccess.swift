//
//  APIAccess.swift
//  flujopago
//
//  Created by Rodrigo Astorga on 1/21/19.
//  Copyright © 2019 rastorga. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireMapper

class ApiAccess {
    
    typealias completionPayMethod = (_ result: [PayMethod]?, _ error: NSError?) -> Void
    typealias completionBank = (_ result: [Bank]?, _ error: NSError?) -> Void
    typealias completionInstallments = (_ result: [Cost]?, _ error: NSError?) -> Void
    typealias completionData = (_ result: DataResponse<Data>?, _ error: NSError?) -> Void
    
    
    private static let publicKey = "444a9ef5-8a6b-429f-abdf-587639155d88"
    static let mountRplc = "{MOUNT}"
    static let payMethodRplc = "{PAYMETHOD.ID}"
    static let issuerRplc = "{ISSUER.ID}"
    
    static let endpointPayMethods = "https://api.mercadopago.com/v1/payment_methods?public_key=\(publicKey)"
    static let endpointBanks = "https://api.mercadopago.com/v1/payment_methods/card_issuers?public_key=\(publicKey)&payment_method_id="
    static let endpointRecomendedMessage = "https://api.mercadopago.com/v1/payment_methods/installments?public_key=\(publicKey)&amount=\(mountRplc)&payment_method_id=\(payMethodRplc)&issuer.id=\(issuerRplc)"
    
    class func sharedInstance() -> ApiAccess {
        struct Static {
            static let instance = ApiAccess()
        }
        return Static.instance
    }
    
    func getRequest(_ url: String, completionHandler: @escaping completionData)-> Void{
        Alamofire.request(url)
            .responseData { (data) in
                completionHandler(data,nil)
        }
    }
    
    func getPayMethod(_ url: String, completionHandler: @escaping completionPayMethod)-> Void{    
        Alamofire.request(url, method: .get
            , parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseObject { (response: DataResponse<[PayMethod]>) in
                switch response.result {
                case let .success(data):
                    completionHandler(data,nil)
                case let .failure(error):
                    completionHandler(nil,error as NSError)
                }
        }
    }
    
    func getBanks(_ url: String, completionHandler: @escaping completionBank)-> Void{
        Alamofire.request(url, method: .get
            , parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseObject { (response: DataResponse<[Bank]>) in
                switch response.result {
                case let .success(data):
                    completionHandler(data,nil)
                case let .failure(error):
                    completionHandler(nil,error as NSError)
                }
        }
    }
    
    func getRecommendedMessage(_ url: String, completionHandler: @escaping completionInstallments)-> Void{
        Alamofire.request(url, method: .get
            , parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseObject { (response: DataResponse<[Installment]>) in
                switch response.result {
                case let .success(data):
                    completionHandler(data.first?.payer_costs,nil)
                case let .failure(error):
                    completionHandler(nil,error as NSError)
                }
        }
    }
    
}
