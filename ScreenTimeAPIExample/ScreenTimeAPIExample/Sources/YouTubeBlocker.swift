//
//  YouTubeBlocker.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/26.
//

import Foundation
import ManagedSettings
import DeviceActivity

struct YouTubeBlocker {
    
    let store = ManagedSettingsStore()
    let model = MyModel.shared
    
    // 앱 차단 로직
    func block(completion: @escaping (Result<Void, Error>) -> Void) {
        // 선택한 앱 토큰 가져오기
        let selectedAppTokens = model.selectedAppsTokens
        
        // DeviceActivityCenter를 사용하여 모든 선택한 앱 토큰에 대한 액티비티 차단
        let deviceActivityCenter = DeviceActivityCenter()
        
        // 하루종일 차단하도록 DeviceActivitySchedule 설정
        let blockSchedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )
        
        store.shield.applications = selectedAppTokens
        do {
            try deviceActivityCenter.startMonitoring(DeviceActivityName.daily, during: blockSchedule)
        } catch {
            completion(.failure(error))
            return
        }
        completion(.success(()))
    }
    
    func unblockAllApps() {
        store.shield.applications = []
    }
    
}
