//
//  AppLaunchChecker.swift
//  SnapTag
//
//  Created by izumi on 2024/12/01.
//

import Foundation

final class AppLaunchChecker {
    private let isFirstLaunchKey = "isFirstLaunch"

    var ifFirstLaunch: Bool {
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: isFirstLaunchKey) {
            return false
        } else {
            userDefaults.set(true, forKey: isFirstLaunchKey)
            return true
        }
    }
}
