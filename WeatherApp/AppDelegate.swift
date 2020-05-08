//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Tushar on 29/09/19.
//  Copyright © 2019 Tushar. All rights reserved.
//

import UIKit
import Moya
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let locationServices = LocationServices()
    let forecastAPIProvider = MoyaProvider<ForecastAPIProvider>()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        locationServices.newestlocation = { [weak self] coordinate in
            guard let self = self, coordinate != nil else { return }
            print(coordinate)
            self.getforecast(for: coordinate)
        }
        
        locationServices.statusUpdated = { [weak self] status in
            if status == .authorizedWhenInUse {
                self?.locationServices.getLocation()
            }
            
        }
        
        switch locationServices.status {
        case .notDetermined:
            locationServices.getPermission()
        case .authorizedWhenInUse:
            locationServices.getLocation()
        default:
            return false
        }
        return true
    }
    
    
    func getforecast(for coordinate: CLLocationCoordinate2D) {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "DARKSKY_API_KEY") as! String
        
//                let url = URL(string: "https://api.darksky.net/forecast/\(apiKey)/\(coordinate.latitude),\(coordinate.longitude)")!
//
//               let task =  URLSession.shared.dataTask(with: url) { (da, re, err) in
//                do {
//                    let forecast1 = try JSONSerialization.jsonObject(with: da!, options: .mutableContainers)
//                    print(forecast1)
//                    let reponse = try JSONDecoder().decode(Forecast.self, from: da!)
//                    print(reponse)
//                } catch (let error) {
//                    print(error)
//                }
//                }
//        task.resume()

        forecastAPIProvider.request(.forecast(apiKey, coordinate.latitude, coordinate.longitude)) { (result) in
            switch result {
            case .success(let response):
                do {
//                    let reponse = try JSONDecoder().decode(Forecast.self, from: response.data)
//                    print(reponse)

                    let forecast = try Forecast(data: response.data)
                    print(forecast)
                    let viewModel = forecast.daily.data.compactMap(ForecastViewModel.init)
                    let viewController = AppDelegate.viewControllerInNav(ofType: ForecastTableViewController.self, in: self.window)
                    viewController?.viewModel = viewModel
                } catch(let error) {
                    print("Error::", error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func viewControllerInNav<T>(ofType: T.Type, in window: UIWindow?) -> T? {
        return (window?.rootViewController
            .flatMap { $0 as? UINavigationController }?
            .viewControllers
            .first(where: { $0 is T }) as? T?)!
    }
}

