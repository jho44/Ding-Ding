//
//  WorkoutSession.swift
//  Workout Alarm
//
//  Created by Jessica Ho on 8/1/19.
//  Copyright © 2019 Jessica Ho. All rights reserved.
//

import Foundation

class WorkoutSession {
    private (set) var startDate: Date!
    private (set) var endDate: Date!
    
    func start() {
        startDate = Date()
    }
    
    func end() {
        endDate = Date()
    }
    
    func clear() {
        startDate = nil
        endDate = nil
    }
    
    var completeWorkout: WorkoutSession {
        return WorkoutSession()
    }
}
