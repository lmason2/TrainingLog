//
//  Season.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/13/20.
//

import Foundation

class Season {
    var name: String
    var startDate: Date
    var endDate: Date
    var mileage: Int
    
    init(name: String, start: Date, end: Date, mileage: Int) {
        self.name = name
        self.startDate = start
        self.endDate = end
        self.mileage = mileage
    }
}
