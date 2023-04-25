//
//  BlockingManager.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/25.
//

import ManagedSettings

extension ManagedSettingsStore.Name {
    static let youTube = Self("YouTube")
}

final class BlockingManager {
    func managedSettingStoreSetup() {
        // TODO: ActivityCategoryToken을 가져와야 함
//        let youTubeCategory = ActivityCategoryToken()
//        let youTubeStore = ManagedSettingsStore(named: .youTube)
//        youTubeStore.shield.applicationCategories = .specific(except: [youTubeCategory])
//        youTubeStore.shield.webDomainCategories = .specific(except: [youTubeCategory])
    }
}
