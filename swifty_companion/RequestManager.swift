//
//  RequestManager.swift
//  swifty_companion
//
//  Created by Oleksii KUCHKO on 9/9/19.
//  Copyright © 2019 Oleksii KUCHKO. All rights reserved.
//
import Alamofire
import UIKit
import SwiftyJSON

class RequestManager: UIViewController {

    private var site: String = "https://api.intra.42.fr/"
    private let uid : String = "9a9c061cc666f3b02c2b8e9a51bd8286662892f25209c757428f71703f50dcd2"
    private let secret : String = "eec4d2017d30bec21f828755daa5d5cd1bf16def711b86061232a4347b65fb5c"
    
    func getToken(completionHandler: @escaping(JSON?, String?) -> Void) {
        Alamofire.request(self.site + "oauth/token?grant_type=client_credentials&client_id=\(uid)&client_secret=\(secret)", method: .post).authenticate(user: uid, password: secret).responseJSON { response in
                if response.data != nil {
                    completionHandler(JSON(response.data!), nil)
                } else {
                    completionHandler(nil, "Error request")
                }
            }
    }
    
    func requestInfoAPI(searchURL : String, token : String, completionHandler: @escaping(JSON?, String?) -> Void) {
        let requestUrl = self.site + searchURL
        let headers = ["Authorization": "Bearer " + token]
        request(requestUrl, method: .get, headers: headers).responseJSON { response in
            if response.data != nil && response.result.isSuccess && JSON(response.data!).isEmpty == false {
                completionHandler(JSON(response.data!), nil)
            } else {
                    completionHandler(nil, "Error request")
            }
        }
    }
    

}
