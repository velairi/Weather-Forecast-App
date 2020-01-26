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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        updateWeatherForLocation(location: "New York")
    }

    func updateWeatherForLocation (location:String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        if let weatherData = results {
                            self.forecastData = weatherData
                            print("This is printing out my daily forecasts: ", self.forecastData)
                            DispatchQueue.main.async {
                                self.tableview.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"

        return dateFormatter.string(from: date!)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let weatherObject = forecastData[indexPath.section]
        cell.textLabel?.text = "Highs: \(weatherObject.highTemp)°F \n" + "Lows: \(weatherObject.lowTemp)°F"
        cell.detailTextLabel?.text = "\(Int(weatherObject.temperature)) °F"
        cell.imageView?.image = UIImage(named: weatherObject.icon)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailsViewController()
        self.navigationController?.pushViewController(detailsVC, animated: true)
        tableview.deselectRow(at: indexPath, animated: true)
    }
}
