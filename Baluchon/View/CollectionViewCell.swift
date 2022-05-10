//
//  CollectionViewCell.swift
//  Baluchon
//
//  Created by Kevin Bertrand on 25/04/2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var weatherConditionView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 25
    }
    
    /// Configure the collection view cell with a weather object
    func configure(with weather: Weather) {
        weatherConditionView.image = UIImage(named: weather.weather[0].main)
        cityLabel.text = "\(weather.name), \(weather.sys.country)"
        temperatureLabel.text = "\(weather.main.temp) °C"
        minimumTemperatureLabel.text = "Min: \(weather.main.temp_min) °C"
        maximumTemperatureLabel.text = "Max: \(weather.main.temp_max) °C"
        sunriseLabel.text = "\(weather.sys.sunrise)"
        sunsetLabel.text = "\(weather.sys.sunset)"
    }
}
