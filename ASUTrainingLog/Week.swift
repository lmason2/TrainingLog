//
//  Week.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/13/20.
//

import Foundation

// Class to contain a week of training
class Week {
    var number: Int // Number week in the season
    var mileage: Int // Total mileage of the week
    
    /*
     * EVC for the week with all fields set
     */
    init(number: Int, mileage: Int) {
        self.number = number
        self.mileage = mileage
    }
}
