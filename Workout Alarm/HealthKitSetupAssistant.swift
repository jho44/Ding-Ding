//
//  HealthKitSetupAssistant.swift
//  Workout Alarm
//
//  Created by Jessica Ho on 8/1/19.
//  Copyright © 2019 Jessica Ho. All rights reserved.
//

import HealthKit

class HealthKitSetupAssistant {
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
      }
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        //1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
          completion(false, HealthkitSetupError.notAvailableOnDevice)
          return
        }
        
        //2. Prepare the data types that will interact with HealthKit
        
        //3. Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = [/*activeEnergy,*/
                                                        HKObjectType.workoutType()]
        let healthKitTypesToRead: Set<HKObjectType> = [/*dateOfBirth,*/
                                                        HKObjectType.workoutType()]
        //but I don't care about the user's data
        
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
}
