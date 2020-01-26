//
//  Weather.swift
//  GOAT Take-Home Project
//
//  Created by Valerie Don on 1/25/20.
//  Copyright © 2020 Valerie Don. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    let summary: String
    let icon: String
    let temperature: Double
    let highTemp: Double
    let lowTemp: Double

    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }


    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}

        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}

        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("temp is missing")}

        guard let highTemp = json["temperatureHigh"] as? Double else {throw
            SerializationError.missing("highTemp is missing")}

        guard let lowTemp = json["temperatureLow"] as? Double else {throw
            SerializationError.missing("lowTemp is missing")}

        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.highTemp = highTemp
        self.lowTemp = lowTemp
    }

    static let basePath = "https://api.darksky.net/forecast/5e45248c76be1653bb55125b26381ee4/"

    static func forecast(withLocation location: CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {

        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)

        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in

            var forecastArray: [Weather] = []

            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }

                    }
                } catch {
                    print(error.localizedDescription)
                }
                completion(forecastArray)
            }
        }
        task.resume()
    }
}
