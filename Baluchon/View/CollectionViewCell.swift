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
    
    func configure(with weather: Weather) {
        weatherConditionView.image = UIImage(named: weather.weatherCondition)
        cityLabel.text = weather.city
        temperatureLabel.text = "\(weather.temperature) °C"
        minimumTemperatureLabel.text = "Min: \(weather.minTemperature) °C"
        maximumTemperatureLabel.text = "Max: \(weather.maxTemperature) °C"
        sunriseLabel.text = weather.sunrise
        sunsetLabel.text = weather.sunset
    }
}
