//
//  DailyInfoForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Tushar on 29/09/19.
//  Copyright © 2019 Tushar. All rights reserved.
//

import UIKit

class DailyInfoForecastTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var infoImage: UIImageView!
    
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpData(model: ForecastDispalyModel) {
        dayLabel.text = "\(model.low) - \(model.heigh)ºF"
        tempLabel.text = model.dayoftheWeek
        infoImage.image = model.image
    }
}
