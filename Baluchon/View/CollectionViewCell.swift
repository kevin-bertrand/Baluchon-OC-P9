//
//  CollectionViewCell.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var weatherConditionView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 25
    }
    
    /// Configure the collection view cell with a weather object
    func configure(with weather: Weather) {
        print(weather)
        if let data = weather.icon {
            weatherConditionView.image = UIImage(data: data)
        }

        weatherConditionLabel.text = weather.weather[0].description
        cityLabel.text = "\(weather.name), \(weather.sys.country)"
        temperatureLabel.text = "\(weather.main.temp) °C"
        minimumTemperatureLabel.text = "Min: \(weather.main.temp_min) °C"
        maximumTemperatureLabel.text = "Max: \(weather.main.temp_max) °C"
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone(identifier: "UTC")
        dateFormater.dateFormat = "HH:mm"
        sunriseLabel.text = getTime(for: weather.sys.sunrise, timezone: weather.timezone)
        sunsetLabel.text = getTime(for: weather.sys.sunset, timezone: weather.timezone)
    }
    
    private func getTime(for time: Date, timezone: Int) -> String {
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone(secondsFromGMT: timezone)
        dateFormater.dateFormat = "HH:mm"
        return dateFormater.string(from: time)
    }
}
