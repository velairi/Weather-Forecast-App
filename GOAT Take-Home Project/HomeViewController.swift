//
//  HomeViewController.swift
//  GOAT Take-Home Project
//
//  Created by Valerie Don on 1/25/20.
//  Copyright © 2020 Valerie Don. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!

    var forecastData = [Weather]()
    var dates: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UINib(nibName: "ForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        updateWeatherForLocation(location: "New York")
        tableview.allowsSelection = true
        dates = getDates()
    }

    func updateWeatherForLocation (location:String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        if let weatherData = results {
                            self.forecastData = weatherData
                            DispatchQueue.main.async {
                                self.tableview.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }

    func getDates() -> [String] {
        var currentDay = 0, lastDay = 7
        while currentDay <= lastDay {
            let date = Calendar.current.date(byAdding: .day, value: currentDay, to: Date())
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            dates.append(dateFormatter.string(from: date!))
            currentDay += 1
        }
        return dates
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! ForecastTableViewCell
        let weatherObject = forecastData[indexPath.row]
        let date = dates[indexPath.row]
        cell.forecastLabel.font = UIFont(name: "Futura", size: 15)
        cell.forecastLabel.text = "\(date) \n" + "Highs: \(weatherObject.highTemp)°F \n" + "Lows: \(weatherObject.lowTemp)°F"
        cell.iconImageView?.image = UIImage(named: weatherObject.icon)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailsViewController()
        let weatherObject = forecastData[indexPath.row]
        detailsVC.summaryLabelString = weatherObject.summary
        self.navigationController?.pushViewController(detailsVC, animated: true)
        tableview.deselectRow(at: indexPath, animated: true)
    }
}
