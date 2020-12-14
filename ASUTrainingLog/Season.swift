//
//  Season.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/13/20.
//

import Foundation

// Class to contain a season of training
class Season {
    var name: String // Name of season
    var startDate: Date // Start date
    var endDate: Date // End date
    var mileage: Int // Total mileage in season
    
    /*
     * EVC for all values in the class
     */
    init(name: String, start: Date, end: Date, mileage: Int) {
        self.name = name
        self.startDate = start
        self.endDate = end
        self.mileage = mileage
    }
}
