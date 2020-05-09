//
//  ForecastTableViewController.swift
//  WeatherApp
//
//  Created by Tushar on 29/09/19.
//  Copyright © 2019 Tushar. All rights reserved.
//

import UIKit
import CoreLocation
import Moya

class ForecastTableViewController: UITableViewController {
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    let viewModel = ForecastViewModel()
    
    var displayModel: [ForecastDispalyModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
        
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 70.0
        
        viewModel.delegate = self
        viewModel.locationPermession()
        addActivityIndicatory()
        activityIndicator.startAnimating()

    }

    /// Added Activity Indicatory
    func addActivityIndicatory() {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        self.view.addSubview(activityIndicator)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyInfoForecastTableViewCell", for: indexPath) as! DailyInfoForecastTableViewCell
        cell.setUpData(model: displayModel[indexPath.row])
        return cell
    }
}


extension ForecastTableViewController: DisplayModelProtocol {
    func displayWeatherData(with displayMode: [ForecastDispalyModel]) {
        self.displayModel = displayMode
        activityIndicator.stopAnimating()

    }
}
