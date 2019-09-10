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

class ViewController: UIViewController, UITextFieldDelegate {
    
    private var checkOneClick: Bool = false
    private var token: String = ""
    private var tokenExpTime: Int = 0
    private var studentJSON: JSON?
    private var coalitionJSON: JSON?
    private let requestManager = RequestManager()
    
    @IBAction func searchUser(_ sender: UIButton) {
        if self.checkOneClick == false {
            self.checkOneClick = true
            searchUserFunc()
        }
    }
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var userNameInput: UITextField!
    
    
    func searchUserFunc() {
        print("token is: \(self.token) with expiring time \(self.tokenExpTime)")
        let timestamp = Int(NSDate().timeIntervalSince1970)
        if (timestamp > self.tokenExpTime) {
            authorizeAPI()
        }
        if self.token != "" {
            print("access to API is granded")
            self.userNameInput.text = self.userNameInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if self.userNameInput.text != "" && self.userNameInput.text != nil && self.userNameInput.text?.isEmpty == false {
                requestForUser(userSearchName: self.userNameInput.text!)
            } else {
                self.checkOneClick = false
            }
        } else {
            self.checkOneClick = false
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStudentsInfo",
            let destinationVC = segue.destination as? SecondViewController {
                destinationVC.dataStudent = studentJSON
                destinationVC.dataCoalition = coalitionJSON
        }
    }

    
    func loadBackground() {
        if let backgroungImg = URL(string: "https://signin.intra.42.fr/assets/background_login-a4e0666f73c02f025f590b474b394fd86e1cae20e95261a6e4862c2d0faa1b04.jpg") {
            if let isbackgroungImg = try? Data(contentsOf: backgroungImg) {
                DispatchQueue.main.async {
                    self.backgroundImage.image = UIImage(data: isbackgroungImg)
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.studentJSON = nil
        self.coalitionJSON = nil
        self.navigationController?.navigationBar.isHidden = true
        self.checkOneClick = false
        authorizeAPI()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBackground()
        let tapp: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapp)
        userNameInput.delegate = self
    }

    //MARK: enter keyboard press
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        searchUserFunc()
        dismissKeyboard()
        return true
    }
    
    //MARK: hide keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController {
    func alertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension ViewController {
    //MARK: access API and get token
    func authorizeAPI() {
        requestManager.getToken(completionHandler: {(response, error) in
            if response != nil {
                print(response!)
                self.token = response?["access_token"].string ?? ""
                if self.token != "" {
                    //MARK: SET token EXPIRINGTIME
                    let creationTokenTime = response?["created_at"].int ?? 0
                    let tokenLifeTime = response?["expires_in"].int ?? 0
                    self.tokenExpTime = creationTokenTime != 0 && tokenLifeTime != 0 ? creationTokenTime + tokenLifeTime : 0
                }
                if self.token == "" || self.tokenExpTime == 0 {
                    self.alertError(title: "Failed", message: "42 API access is locked")
                    print("42 API access is locked")
                }
            } else {
                print(error!)
            }
        })
    }
    
    func requestForUser(userSearchName : String) -> Void {
        requestManager.requestInfoAPI(searchURL: "v2/users/\(userSearchName)/", token: self.token) { (studentJSON, errorString) in
            if studentJSON != nil {
                self.studentJSON = studentJSON
                self.requestForCoalition(userSearchName: userSearchName)
            } else {
                self.alertError(title: "Please", message: "Insert valid login")
                self.checkOneClick = false
            }
        }
    }
    
    func requestForCoalition(userSearchName : String) -> Void {
        requestManager.requestInfoAPI(searchURL: "v2/users/\(userSearchName)/coalitions/", token: self.token) { (coalitionJSON, errorString) in
            if coalitionJSON != nil {
                self.coalitionJSON = coalitionJSON
            } else {
                print(errorString!)
            }
            DispatchQueue.main.async {
                self.checkOneClick = false
                self.performSegue(withIdentifier: "showStudentsInfo", sender: .none)
            }
        }
    }
}
