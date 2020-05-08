//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Tushar on 30/09/19.
//  Copyright © 2019 Tushar. All rights reserved.
//

import UIKit

struct ForecastViewModel {
    let dayoftheWeek: String
    let heigh: Int
    let low: Int
    let image: UIImage?
    
    static func formate(_ date: Date) -> String {
        let formater = DateFormatter()
        formater.dateFormat = "EEEE"
        return formater.string(from: date)
    }
}

extension ForecastViewModel {
    
    init?(dailyForecast: DailyDatum) {
        let date = Date(timeIntervalSince1970: TimeInterval(dailyForecast.time))
        dayoftheWeek = ForecastViewModel.formate(date)
        heigh = Int(dailyForecast.temperatureHigh)
        low = Int(dailyForecast.temperatureLow)
        image = UIImage(named: dailyForecast.icon)
    }
    
}
