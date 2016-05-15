//
//  WeekCell.swift
//  WeatherDemo-Just
//
//  Created by YaoJ on 16/5/14.
//  Copyright © 2016年 瑶瑾瑾. All rights reserved.
//

import UIKit

class WeekCell: UITableViewCell {

    @IBOutlet weak var labelWeek: UILabel!
    @IBOutlet weak var labelToday: UILabel!
    @IBOutlet weak var imgWeatherIcon: UIImageView!
    @IBOutlet weak var labelHighTemp: UILabel!
    @IBOutlet weak var labelLowTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
