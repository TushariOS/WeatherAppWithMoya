//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Tushar on 30/09/19.
//  Copyright © 2019 Tushar. All rights reserved.
//

import UIKit
import CoreLocation
import Moya

protocol DisplayModelProtocol: class {
    func displayWeatherData(with displayMode: [ForecastDispalyModel])
}

class ForecastViewModel {
    
    let locationServices = LocationServices()
    let forecastApiProvider = MoyaProvider<ForecastAPIProvider>()
    
    weak var delegate: DisplayModelProtocol?
    
    func locationPermession() {
        locationServices.newestlocation = { coordinate in
            self.getforecast(for: coordinate)
        }
        
        locationServices.statusUpdated = { status in
            if status == .authorizedWhenInUse {
                self.locationServices.getLocation()
            }
        }
        
        switch locationServices.status {
        case .notDetermined:
            locationServices.getPermission()
        case .authorizedWhenInUse:
            locationServices.getLocation()
        default:
            print("Default")
        }
    }
    
    func getforecast(for coordinate: CLLocationCoordinate2D) {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "DARKSKY_API_KEY") as! String
        forecastApiProvider.request(.forecast(apiKey, coordinate.latitude, coordinate.longitude)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let forecast = try Forecast(data: response.data)
                    let viewModel = forecast.daily.data.compactMap(ForecastDispalyModel.init)
                    self.delegate?.displayWeatherData(with: viewModel)
                } catch(let error) {
                    print("Error::", error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}


struct ForecastDispalyModel {
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

extension ForecastDispalyModel {
    init?(dailyForecast: DailyDatum) {
        let date = Date(timeIntervalSince1970: TimeInterval(dailyForecast.time))
        dayoftheWeek = ForecastDispalyModel.formate(date)
        heigh = Int(dailyForecast.temperatureHigh)
        low = Int(dailyForecast.temperatureLow)
        image = UIImage(named: dailyForecast.icon)
    }
}
