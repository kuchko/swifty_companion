//
//  SkillsTableViewCell.swift
//  swifty_companion
//
//  Created by Oleksii KUCHKO on 9/10/19.
//  Copyright © 2019 Oleksii KUCHKO. All rights reserved.
//

import UIKit
import SwiftyJSON

class SkillsTableViewCell: UITableViewCell {

    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var skillValue: UILabel!
    @IBOutlet weak var skillPV: UIProgressView!
    
    var data: JSON? {
        didSet {
            if data != nil {
                skillName.text = data?["name"].string ?? ""
                let skillLevel = data?["level"].float ?? 0.0
                skillValue.text = String(skillLevel)
                skillPV.setProgress(skillLevel / 21.0, animated: true)
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
