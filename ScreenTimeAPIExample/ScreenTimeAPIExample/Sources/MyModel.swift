//
//  MyModel.swift
//  ScreenTimeAPIExample
//
//  Created by Doyeon on 2023/04/26.
//

import Foundation
import FamilyControls
import ManagedSettings

final class MyModel: ObservableObject {
    static let shared = MyModel()
    
    @Published var newSelection: FamilyActivitySelection = .init()
    
    var selectedAppsTokens: Set<ApplicationToken> {
        newSelection.applicationTokens
    }
}
