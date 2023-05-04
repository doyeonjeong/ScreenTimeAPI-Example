# ScreenTimeAPI-Example
Screen Time API 를 이용해서 특정 앱 Block 해보기

## 기존 스크린 타임 : 비밀번호로 해제 가능
![RPReplay_Final1683190279](https://user-images.githubusercontent.com/108422901/236157002-404c0a4a-a9e6-4e98-b0b3-ea0ae0ef450a.GIF)
![RPReplay_Final1683190360](https://user-images.githubusercontent.com/108422901/236157048-657616a8-62ff-4164-aa74-d2c531e5821e.GIF)

## 스크린 타임 API 사용 : 비밀번호 입력할 수 없는 상태로 제한됨
![RPReplay_Final1683190312](https://user-images.githubusercontent.com/108422901/236157023-8f36ce1d-59c2-42dd-987c-05143893c496.GIF)
![RPReplay_Final1683190326](https://user-images.githubusercontent.com/108422901/236157032-9a679b41-58d5-4726-9a85-fdebc25df170.GIF)


## 작동순서
1. 앱이 실행되면 ViewController의 `viewDidLoad()` 메서드가 호출되어 초기 설정이 수행됩니다.
2. 사용자가 "차단할 앱 목록 확인하기" 버튼을 클릭하면 `SwiftUIView`에서 팝업이 표시되고, 사용자는 차단하려는 앱 목록을 선택할 수 있습니다.
3. 사용자가 앱 목록을 선택하면 `BlockingApplicationModel`에 선택한 앱 목록이 저장됩니다.
4. 사용자가 '차단하기' 버튼을 누르면 `ViewController`에서 `YouTubeBlocker`의 `block()` 메서드가 호출되어 선택한 앱을 차단합니다.
5. 사용자가 '해제하기' 버튼을 누르면 `ViewController`에서 `YouTubeBlocker`의 `unblockAllApps()` 메서드가 호출되어 모든 앱의 차단을 해제합니다.

### BlockingApplicationModel
- 앱 차단을 위한 데이터 모델, 사용자가 선택한 앱 목록 저장<br>
- ObservableObject 프로토콜 채택, 선택한 앱 목록이 변경되면 자동으로 관련된 뷰 업데이트

<details>
<summary> 소스 코드 </summary>

```swift
final class BlockingApplicationModel: ObservableObject {
    static let shared = BlockingApplicationModel()
    
    @Published var newSelection: FamilyActivitySelection = .init()
    
    var selectedAppsTokens: Set<ApplicationToken> {
        newSelection.applicationTokens
    }
}
```
</details>

### YouTubeBlocker
- 앱 차단을 수행하는 로직
- `block()` : 선택한 앱을 차단하는 기능
- `unblockAllApps()` : 모든 앱의 차단을 해제하는 기능

<details>
<summary> 소스 코드 </summary>

```swift
struct YouTubeBlocker {
    
    let store = ManagedSettingsStore()
    let model = BlockingApplicationModel.shared
    
    func block(completion: @escaping (Result<Void, Error>) -> Void) {

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
```
</details>

### SwiftUIView
- 사용자 인터페이스를 구성하는 SwiftUI 뷰
- 버튼을 통해 앱 목록을 확인할 수 있음
- 선택한 앱 목록을 BlockingApplicationModel에 저장

<details>
<summary> 소스 코드 </summary>

```swift
struct SwiftUIView: View {
    
    @EnvironmentObject var model: BlockingApplicationModel
    @State var isPresented = false
    
    var body: some View {
        VStack {
            Button(action: { isPresented.toggle() }) {
                Text("차단할 앱 목록 확인하기 🤗")
                    //(생략)
            }
                .familyActivityPicker(isPresented: $isPresented, selection: $model.newSelection)
        }
    }
}

```
</details>

### ViewController
- 앱 차단과 관련된 액션을 처리하는 뷰 컨트롤러
- '차단하기' 버튼 : YouTubeBlocker의 block() 메서드가 호출되어 선택한 앱을 차단
- '해제하기' 버튼 : unblockAllApps() 메서드를 호출하여 모든 앱의 차단을 해제

<details>
<summary> 소스 코드 </summary>

```swift
final class ViewController: UIViewController {

    // MARK: - Properties
    var hostingController: UIHostingController<SwiftUIView>?
    
    private let _center = AuthorizationCenter.shared
    private let _youTubeBlocker = YouTubeBlocker()

    private lazy var _contentView: UIHostingController<some View> = {
        let model = BlockingApplicationModel.shared
        let hostingController = UIHostingController(
            rootView: SwiftUIView()
                .environmentObject(model)
        )
        return hostingController
    }()

    private let _blockButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("차단하기", for: .normal)
        // (생략)
        return button
    }()
    
    private let _releaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("해제하기", for: .normal)
        // (생략)
        return button
    }()
    
    private let _buttonStackView: UIStackView = {
        let stackView = UIStackView()
        // (생략)
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        _setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _requestAuthorization()
    }
}

// MARK: - Setup
extension ViewController {
    private func _setup() {
        _addSubviews()
        _setConstraints()
        _addTargets()
    }

    private func _addTargets() {
        _blockButton.addTarget(self, action: #selector(_tappedBlockButton), for: .touchUpInside)
        _releaseButton.addTarget(self, action: #selector(_tappedReleaseButton), for: .touchUpInside)
    }

    private func _addSubviews() {
        // (생략)
    }

    private func _setConstraints() {
        // (생략)
    }
}

// MARK: - Actions
extension ViewController {
    @objc private func _tappedBlockButton() {
        _youTubeBlocker.block { result in
            switch result {
            case .success():
                print("차단 성공")
            case .failure(let error):
                print("차단 실패: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func _tappedReleaseButton() {
        print("차단 해제")
        _youTubeBlocker.unblockAllApps()
    }
    
    private func _requestAuthorization() {
        Task {
            do {
                try await _center.requestAuthorization(for: .individual)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
```
</details>
