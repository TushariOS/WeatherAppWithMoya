//
//  ForecastTableViewController.swift
//  WeatherApp
//
//  Created by Tushar on 29/09/19.
//  Copyright © 2019 Tushar. All rights reserved.
//

import UIKit

class ForecastTableViewController: UITableViewController {
    
    var viewModel: [ForecastViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
        
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 70.0
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyInfoForecastTableViewCell", for: indexPath) as! DailyInfoForecastTableViewCell
        cell.setUpData(model: viewModel[indexPath.row])
        return cell
    }
}
