//
//  AttachCell.swift
//  WeatherDemo-Just
//
//  Created by YaoJ on 16/5/14.
//  Copyright © 2016年 瑶瑾瑾. All rights reserved.
//

import UIKit

class AttachCell: UITableViewCell {

    @IBOutlet weak var labelWind: UILabel!
    @IBOutlet weak var labelHumid: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
