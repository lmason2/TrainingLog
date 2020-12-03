//
//  TrainingDay.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/3/20.
//

import Foundation

class TrainingDay {
    var amMileage: Int
    var pmMileage: Int
    var totalMileage: Int
    var dayOfMonth: String
    
    init(amMileage: Int, pmMileage: Int, dayOfMonth: String) {
        self.amMileage = amMileage
        self.pmMileage = pmMileage
        self.totalMileage = amMileage + pmMileage
        self.dayOfMonth = dayOfMonth
    }
}
