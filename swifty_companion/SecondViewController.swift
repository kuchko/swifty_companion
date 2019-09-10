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
    @IBOutlet weak var coalitionImage: UIImageView!
    @IBOutlet weak var levelPV: UIProgressView!
    @IBOutlet weak var skillsTableView: UITableView!
    @IBOutlet weak var projectsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        // MARK: FILL_USER_INFO_LABELS
        
        guard dataStudent != nil else { return }        
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
        if let coalitionImg = URL(string: dataCoalition?[0]["cover_url"].string ?? "") {
            if let iscoalitionImg = try? Data(contentsOf: coalitionImg) {
                self.coalitionImage.image = UIImage(data: iscoalitionImg)
            }
        }
    }

}

extension SecondViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == skillsTableView {
            return dataStudent?["cursus_users"][0]["skills"].count ?? 0
        } else {
              return dataStudent?["projects_users"].count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == skillsTableView {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as! SkillsTableViewCell
            cell.data = dataStudent?["cursus_users"][0]["skills"][indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectsTableViewCell
            cell.data = dataStudent?["projects_users"][indexPath.row]
            return cell
        }
    }
}
