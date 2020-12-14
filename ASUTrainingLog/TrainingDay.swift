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
    var dayName: String
    var easy: Bool
    var workout: Bool
    var race: Bool
    var longRun: Bool
    var notes: String
    
    init(amMileage: Int, pmMileage: Int, dayOfMonth: String, dayName: String, easy: Bool, workout: Bool, race: Bool, longRun: Bool, notes: String) {
        self.amMileage = amMileage
        self.pmMileage = pmMileage
        self.totalMileage = amMileage + pmMileage
        self.dayOfMonth = dayOfMonth
        self.dayName = dayName
        self.easy = easy
        self.workout = workout
        self.race = race
        self.longRun = longRun
        self.notes = notes
    }
}
