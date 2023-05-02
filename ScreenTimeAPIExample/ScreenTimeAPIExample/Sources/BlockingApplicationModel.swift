//
//  MyModel.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/26.
//

import Foundation
import FamilyControls
import ManagedSettings

final class BlockingApplicationModel: ObservableObject {
    static let shared = BlockingApplicationModel()
    
    @Published var newSelection: FamilyActivitySelection = .init()
    
    var selectedAppsTokens: Set<ApplicationToken> {
        newSelection.applicationTokens
    }
}
