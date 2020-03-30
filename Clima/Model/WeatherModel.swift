//
//  WeatherModel.swift
//  Clima
//
//  Created by Slava Pashaliuk on 3/29/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var tempStr: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        var condition = ""
        switch conditionId {
        case 200..<300:
            condition = "cloud.bolt.fill"
        case 300...400:
            condition = "cloud.drizzle"
        case 500..<600:
            condition = "cloud.rain.fill"
        case 600..<700:
            condition = "cloud.snow.fill"
        case 700..<800:
            condition = "cloud.fog"
        case 800:
            condition = "sun.max"
        case 800...805:
            condition = "cloud.fill"
        default:
            condition = "tortoise"
        }
        
        return condition
    }
}
