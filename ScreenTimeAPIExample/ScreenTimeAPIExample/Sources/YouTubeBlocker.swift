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
    let model = BlockingApplicationModel.shared
    
    // 앱 차단 로직
    func block(completion: @escaping (Result<Void, Error>) -> Void) {
        // 선택한 앱 토큰 가져오기
        let selectedAppTokens = model.selectedAppsTokens
        
        // DeviceActivityCenter를 사용하여 모든 선택한 앱 토큰에 대한 액티비티 차단
        let deviceActivityCenter = DeviceActivityCenter()
        
        // 모니터 DeviceActivitySchedule 설정
        let blockSchedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )
        
        store.shield.applications = selectedAppTokens
        do {
            try deviceActivityCenter.startMonitoring(DeviceActivityName.daily, during: blockSchedule)
            // 모니터링이 돼서 리포트가 됐을 때 사용시간이 증가하는시점에 YouTube 사용시간에 대한 트래킹 트리거
            // 3시간 잡았는데 -6분 -> 2시간 45분
            // 토탈시간 이벤트는 시간~끝이 있고 값은 몇분 사용했다는 결과를 반환할 것 같다.
            // 내가 마이너스 한 시간이랑, API에서 반환한 시간이랑 같은지 체크 Validate
            // 맞으면 상관없지만, 만약 다르다면 API에서 측정한 시간 기준으로 재할당하기! (사용자가 보는 기록을 기준으로)
            // 0분이 딱 됐을 때, 블락이 시작되고
            // 앱이 켜졌을 때 시간이 맞는지 체크하고 푸시를 받아야하나? 말아야하나? 체크
            // 앱이 꺼지면 푸시 스케줄링 지우고, 대기열 다 지우고
            // 푸시 정책: 반감기 (1분 미만일 때에만 1분에 1번으로 조절해주기) -> 초단위 / 2
            // 열품타를 보고 하고싶었던 것 -> 다이나믹 아일랜드에서 시간을 캡쳐해줌
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
