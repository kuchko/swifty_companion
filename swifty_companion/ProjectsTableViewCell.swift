//
//  ProjectsTableViewCell.swift
//  swifty_companion
//
//  Created by Oleksii KUCHKO on 9/10/19.
//  Copyright © 2019 Oleksii KUCHKO. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProjectsTableViewCell: UITableViewCell {

    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectMark: UILabel!
    
    var data: JSON? {
        didSet {
            if data != nil {
                projectName.text = data?["project"]["name"].string ?? ""
                projectMark.text = String(data?["final_mark"].int ?? 0)
                if let projectValid = data?["validated?"].bool {
                    if projectValid == true && projectMark.text != "0" {
                        projectMark.textColor = UIColor.green
                    } else {
                        projectMark.textColor = UIColor.red
                    }
                } else {
                   projectMark.textColor = UIColor.gray
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
