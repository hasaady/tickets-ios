//
//  EventlyApp.swift
//  Evently
//
//  Created by Hanan on 04/11/2024.
//

import SwiftUI
import Pulse
import PulseUI
import PulseProxy
import SwiftIContainer
import SwiftNetwork

@main
struct EventlyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var state = AppState()
    @State var showNetworkInspector: Bool = false

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if showNetworkInspector {
                    ConsoleView()
                } else {
                    EventListView()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.didShake)) { _ in
                showNetworkInspector.toggle()
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setUpNetworkInspector()
        return true
    }
    
    private func setUpNetworkInspector() {
        URLSessionProxyDelegate.enableAutomaticRegistration()
        NetworkLogger.enableProxy()
    }
}

extension UIDevice {
    static let didShake = Notification.Name(rawValue: "didShake")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with: UIEvent?) {
        guard motion == .motionShake else { return }
        
        NotificationCenter.default.post(name: UIDevice.didShake, object: nil)
    }
}

class AppState: ObservableObject {
    
    init() {
        registerDependeiies()
    }
    
    func registerDependeiies() {
        CoreDI.register()
        EventsDI.register()
    }
}


struct EventsDI {
    static func register() {
        DIContainer.register(type: EventPublisher<ServicesEvent>.self, singleton: EventPublisher<ServicesEvent>())
        
        DIContainer.register(type: FetchEventsUseCase.self) {
            FetchEventsUseCase()
        }
        
        DIContainer.register(type: EventRepositoryProtocol.self) {
            EventRepository()
        }
        
        DIContainer.register(type: EventRepositoryProtocol.self) {
            EventRepository()
        }
    }
}


struct CoreDI {
    static func register() {
       // DIContainer.register(type: DbContext.self, singleton: DbContextImp())
        
        DIContainer.register(type: DbContext.self) {
            DbContextImp()
        }
        
        DIContainer.register(type: NetworkProvider.self, singleton: NetworkProviderImp(baseURL: "http://172.20.10.4:8080"))
    }
}
