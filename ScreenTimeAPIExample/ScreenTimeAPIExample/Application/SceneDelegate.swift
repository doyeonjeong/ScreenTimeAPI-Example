import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let viewController = ViewController()
        self.window = makeWindow(scene: scene)
        
        configure(
            window: window,
            rootViewController: viewController
        )
    }
}

// MARK: - Private Function
extension SceneDelegate {
    private func makeWindow(scene: UIScene) -> UIWindow? {
        guard let windowScene = (scene as? UIWindowScene) else { return nil }
        return UIWindow(windowScene: windowScene)
    }
    
    private func configure(
        window: UIWindow?,
        rootViewController: UIViewController
    ) {
        guard let window = window else { return }
        window.backgroundColor = .white
        window.overrideUserInterfaceStyle = .light
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
