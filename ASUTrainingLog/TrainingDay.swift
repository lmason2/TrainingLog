//
//  TrainingDay.swift
//  ASUTrainingLog
//
//  Created by Luke Mason on 12/3/20.
//

import Foundation

// Class to represent a training day
class TrainingDay {
    var amMileage: Int // Morning mileage of run
    var pmMileage: Int // Afternoon miileage of run
    var totalMileage: Int
    var dayOfMonth: String // Date in a string
    var dayName: String // Day # where # is associated to week
    
    // Boolean values for type of training day
    var easy: Bool
    var workout: Bool
    var race: Bool
    var longRun: Bool
    
    // Additional notes on training
    var notes: String
    
    /*
     * EVC for all class values passed in
     */
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
