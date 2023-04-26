//
//  ALL.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/26.
//

import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettingsUI
import ManagedSettings

// MARK: - 미사용
class MyShieldConfiguration: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        return ShieldConfiguration(
            backgroundBlurStyle: .regular,
            backgroundColor: .clear,
            icon: .init(named: "curby"),
            title: ShieldConfiguration.Label(
                text: "유튜브 차단",
                color: .black
            ),
            subtitle: ShieldConfiguration.Label(
                text: "차단했쥬 이제 못키쥬 크크루삥뽕",
                color: .black
            )
        )
    }
}

// MARK: - 미사용
class AppShieldActionDelegate: ShieldActionDelegate {

    // 사용자가 차단된 앱에서 행동을 취할 때 호출되는 메서드
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.defer)
        case .secondaryButtonPressed:
            completionHandler(.close)
        @unknown default:
            fatalError()
        }
    }

    // 사용자가 차단된 웹사이트에서 행동을 취할 때 호출되는 메소드
    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.defer)
        case .secondaryButtonPressed:
            completionHandler(.close)
        @unknown default:
            fatalError()
        }
    }

    // 사용자가 차단된 앱 또는 웹사이트의 카테고리에서 행동을 취할 때 호출되는 메소드
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.defer)
        case .secondaryButtonPressed:
            completionHandler(.close)
        @unknown default:
            fatalError()
        }
    }
}

struct YouTubeBlocker {
    
    let shieldConfiguration = MyShieldConfiguration()
    let store = ManagedSettingsStore()
    let model = MyModel.shared
    
    // 유튜브 차단 로직
    func blockYouTube(completion: @escaping (Result<Void, Error>) -> Void) {
        // 선택한 앱 토큰 가져오기
        let selectedAppTokens = model.selectedAppsTokens
        
        // DeviceActivityCenter를 사용하여 모든 선택한 앱 토큰에 대한 액티비티 차단
        let deviceActivityCenter = DeviceActivityCenter()
        
        // 오전 9시부터 오후 5시까지 차단하도록 DeviceActivitySchedule 설정
        let blockSchedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 9),
            intervalEnd: DateComponents(hour: 17),
            repeats: true
        )
        
        store.shield.applications = selectedAppTokens
        
        for appToken in selectedAppTokens {
            do {
                try deviceActivityCenter.startMonitoring(DeviceActivityName.application(appToken), during: blockSchedule)
            } catch {
                completion(.failure(error))
                return
            }
        }
        completion(.success(()))
    }
    
    func unblockAllApps() {
        // 모든 앱의 차단을 해제하려면 shield.applications를 빈 배열로 설정
        store.shield.applications = []
    }
    
}

class MyModel: ObservableObject {
    static let shared = MyModel()
    
    @Published var newSelection: FamilyActivitySelection = .init()
    @Published var selectedApps: Set<ApplicationToken> = []
    
    var selectedAppsTokens: Set<ApplicationToken> {
        newSelection.applicationTokens
    }
    
    var selectionToEncourage: EncourageSelection
    var selectionToDiscourage: DiscourageSelection
    
    private init() {
        // 여기서 선택할 수 있는 어플리케이션들과 이에 대한 설정을 초기화하세요.
        selectionToEncourage = EncourageSelection(applicationTokens: [])
        selectionToDiscourage = DiscourageSelection(applications: [])
    }
    
    struct EncourageSelection {
        var applicationTokens: Set<ManagedSettings.ApplicationToken>
    }
    
    struct DiscourageSelection {
        var applications: Set<ManagedSettings.ApplicationToken>
    }
}


class MyMonitor: DeviceActivityMonitor {
    
    let model = MyModel.shared
    let store = ManagedSettingsStore()
    let center = DeviceActivityCenter()
    
    let schedule = DeviceActivitySchedule(
        intervalStart: DateComponents(hour: 0, minute: 0),
        intervalEnd: DateComponents(hour: 23, minute: 59),
        repeats: true
    )
    
    var events: [DeviceActivityEvent.Name: DeviceActivityEvent] {
        let minutes = 30 // 여기에 원하는 분을 설정하세요.
        return [
            .encouraged: DeviceActivityEvent(
                applications: model.selectedApps,
                threshold: DateComponents(minute: minutes)
            )
        ]
    }
    
    func start() {
        do {
            try center.startMonitoring(.daily, during: schedule, events: events)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        let applications = model.selectionToDiscourage.applications
        store.shield.applications = applications.isEmpty ? nil : applications
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        store.shield.applications = nil
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        store.shield.applications = nil
    }
    
}
