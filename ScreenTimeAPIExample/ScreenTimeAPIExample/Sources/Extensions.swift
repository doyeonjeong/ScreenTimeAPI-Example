//
//  Extensions.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/26.
//

import ManagedSettings
import DeviceActivity

extension DeviceActivityName {
    static let daily = Self("daily")
    static let activity = Self("activity")
    static func application(_ token: ApplicationToken) -> DeviceActivityName {
        return DeviceActivityName("application:\(token)")
    }
}

extension DeviceActivityEvent.Name {
    static let encouraged = Self("encouraged")
}

extension ManagedSettingsStore.Name {
    static let youTube = Self("YouTube")
}
