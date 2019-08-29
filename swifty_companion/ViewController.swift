//
//  ViewController.swift
//  swifty_companion
//
//  Created by Oleksii KUCHKO on 8/27/19.
//  Copyright © 2019 Oleksii KUCHKO. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    private var site: String = "https://api.intra.42.fr"
    private let uid : String = "9a9c061cc666f3b02c2b8e9a51bd8286662892f25209c757428f71703f50dcd2"
    private let secret : String = "eec4d2017d30bec21f828755daa5d5cd1bf16def711b86061232a4347b65fb5c"
    private var token: String = ""




    func authorizeAPI() {
        
        //MARK: access API and get token
        Alamofire.request(self.site + "/oauth/token?grant_type=client_credentials&client_id=\(uid)&client_secret=\(secret)", method: .post)
            .authenticate(user: uid, password: secret)
            .responseJSON { response in
                if response.data != nil {
//                    print(response.data)
                    self.token = JSON(response.data!)["access_token"].string ?? ""
//                    print(response)
                    print(self.token)
                    //MARK: load user by token
                    let userName = "okuchko"
                    let reqUrl = self.site + "v2/users/\(userName)/"
                    let headers = ["Authorization": "Bearer " + self.token]
                    request(reqUrl, method: .get, headers: headers).responseJSON { response in
                        if response.data != nil {
                            debugPrint(response)
                        }
                    }
                    
                } else {
                    print("error")
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeAPI()


    }


}

