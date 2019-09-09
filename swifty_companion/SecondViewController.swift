//
//  SecondViewController.swift
//  swifty_companion
//
//  Created by Oleksii KUCHKO on 9/4/19.
//  Copyright © 2019 Oleksii KUCHKO. All rights reserved.
//

import UIKit
import SwiftyJSON

class SecondViewController: UIViewController {

    var dataStudent : JSON?
    var dataCoalition : JSON?
    
    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var yearAndMonth: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var correctionPoints: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var userFaceImg: UIImageView!
    @IBOutlet weak var levelPV: UIProgressView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        testLabel.text = String(describing: jason)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("DATA IS: \(String(describing: dataStudent))")
        print("DATA 2 IS: \(String(describing: dataCoalition))")
        
        guard dataStudent != nil else { return }
        
        // MARK: FILL_USER_INFO_LABELS
        displayName.text = dataStudent?["displayname"].string ?? ""
        yearAndMonth.text = "\(dataStudent?["pool_year"].string ?? "") \(dataStudent?["pool_month"].string ?? "")"
        mailLabel.text = dataStudent?["email"].string ?? ""
        phoneLabel.text = dataStudent?["phone"].string ?? ""
        walletLabel.text = String(dataStudent?["wallet"].int ?? 0)
        correctionPoints.text = String(dataStudent?["correction_point"].int ?? 0)
        userName.text = dataStudent?["login"].string ?? ""
        locationLabel.text = dataStudent?["location"].string ?? ""
        if let userLevel = dataStudent?["cursus_users"][0]["level"].float {
            levelLabel.text = String(userLevel)
            levelPV.setProgress(userLevel / 21.0, animated: true)
        }
        if let faceImg = URL(string: dataStudent?["image_url"].string ?? "") {
            if let isfaceImg = try? Data(contentsOf: faceImg) {
                self.userFaceImg.image = UIImage(data: isfaceImg)
            }
        }
        
        
//        userFaceImg.image = userFaceImg.image?.maskWithColor(color: .red)
        
        
        
//        self.token = JSON(response.data!)["access_token"].string ?? ""
        
//        debugPrint(JSON(data!))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




//extension UIImage {
//
//    func maskWithColor(color: UIColor) -> UIImage? {
//        let maskImage = cgImage!
//
//        let width = size.width
//        let height = size.height
//        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
//
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
//
//        context.clip(to: bounds, mask: maskImage)
//        context.setFillColor(color.cgColor)
//        context.fill(bounds)
//
//        if let cgImage = context.makeImage() {
//            let coloredImage = UIImage(cgImage: cgImage)
//            return coloredImage
//        } else {
//            return nil
//        }
//    }
//
//}
