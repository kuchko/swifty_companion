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
    
    private var site: String = "https://api.intra.42.fr/"
    private let uid : String = "9a9c061cc666f3b02c2b8e9a51bd8286662892f25209c757428f71703f50dcd2"
    private let secret : String = "eec4d2017d30bec21f828755daa5d5cd1bf16def711b86061232a4347b65fb5c"
    private var token: String = ""
    private var tokenExpTime: Int = 0
    private var userSearchName: String = ""
    private var studentJSON: JSON?
    private var coalitionJSON: JSON?
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var userNameInput: UITextField!
    
    private let defaults = UserDefaults.standard
    
    @IBAction func searchUser(_ sender: UIButton) {
        print("token is: \(self.token) with expiring time \(self.tokenExpTime)")
        let timestamp = Int(NSDate().timeIntervalSince1970)
        if (timestamp > self.tokenExpTime) {
            authorizeAPI()
        }
        if self.token != "" {
            print("access to API is granded")
            //MARK: GET all user info
            self.userSearchName = self.userNameInput.text ?? ""
            self.userSearchName = self.userSearchName.trimmingCharacters(in: .whitespacesAndNewlines)
            if self.userSearchName != "" {
                var reqUrl = self.site + "v2/users/\(self.userSearchName)/"
                var headers = ["Authorization": "Bearer " + self.token]
                request(reqUrl, method: .get, headers: headers).responseJSON { response in
//                    print("RESPONSE IS: \(response)")
//                    print("DATA IS: \(response.data!)")
                    if response.data != nil && response.result.isSuccess && JSON(response.data!).isEmpty == false {
//                        debugPrint(response)
                        //MARK: SEND to next View controller
                        DispatchQueue.main.async {
                            self.studentJSON = JSON(response.data!)
//                            self.performSegue(withIdentifier: "showStudentsInfo", sender: .none)
                        }
                    }
                    else {
                        print("Insert another name")
                    }
                }
                
                
                
                
                
                reqUrl = self.site + "v2/users/\(self.userSearchName)/coalitions/"
                headers = ["Authorization": "Bearer " + self.token]
                request(reqUrl, method: .get, headers: headers).responseJSON { response in
                    //                    print("RESPONSE IS: \(response)")
                    //                    print("DATA IS: \(response.data!)")
                    if response.data != nil && response.result.isSuccess && JSON(response.data!).isEmpty == false {
                        //                        debugPrint(response)
                        //MARK: SEND to next View controller
                        DispatchQueue.main.async {
                            self.coalitionJSON = JSON(response.data!)
                            print(self.coalitionJSON ?? "ERROR")
//                            self.performSegue(withIdentifier: "showStudentsInfo", sender: .none)
                        }
                    }
                    else {
                        print("bad coaltion request")
                    }
                }
                
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showStudentsInfo", sender: .none)
                }
                
                
                
                
                
                
            }
            
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStudentsInfo",
            let destinationVC = segue.destination as? SecondViewController {
                destinationVC.dataStudent = studentJSON
                destinationVC.dataCoalition = coalitionJSON
        }
    }


    //MARK: access API and get token
    func authorizeAPI() {
        Alamofire.request(self.site + "oauth/token?grant_type=client_credentials&client_id=\(uid)&client_secret=\(secret)", method: .post)
            .authenticate(user: uid, password: secret)
            .responseJSON { response in
                if response.data != nil {
                    print(response)
                    self.token = JSON(response.data!)["access_token"].string ?? ""
                    if self.token != "" {
                        //MARK: SET token EXPIRINGTIME
                        let creationTokenTime = JSON(response.data!)["created_at"].int ?? 0
                        let tokenLifeTime = JSON(response.data!)["expires_in"].int ?? 0
                        self.tokenExpTime = creationTokenTime != 0 && tokenLifeTime != 0 ? creationTokenTime + tokenLifeTime : 0
//                        print("token exp time: \(self.tokenExpTime)")
                    }
                    if self.token == "" || self.tokenExpTime == 0 {
                        self.alertError(title: "Failed", message: "42 API access is locked")
                        print("42 API access is locked")
                    }
//                    print(self.token)
                } else {
                    print("Error almofire request")
                }
        }
    }
    

    
    
    
    
    func back() {
        if let newsImage = URL(string: "https://signin.intra.42.fr/assets/background_login-a4e0666f73c02f025f590b474b394fd86e1cae20e95261a6e4862c2d0faa1b04.jpg") {
            if let isNewsImage = try? Data(contentsOf: newsImage) {
                DispatchQueue.main.async {
                    self.backgroundImage.image = UIImage(data: isNewsImage)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        authorizeAPI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        back()
    }


}

extension ViewController {
    func alertError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
