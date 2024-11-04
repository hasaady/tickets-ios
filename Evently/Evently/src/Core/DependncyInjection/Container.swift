//
//  DIContainer.swift
//
//
//  Created by Hanan on 04/02/2024.
//

import Foundation

public final class DIContainer {
    private static let shared = DIContainer()
    private var factories = [String: () -> Any]()
    private var singletons = [String: Any]()

    private init() {}

    public static func register<T>(type: T.Type, factory: @escaping () -> T) {
        DIContainer.shared.factories[String(describing: type)] = factory
    }

    public static func register<T>(type: T.Type, singleton: T) {
        DIContainer.shared.singletons[String(describing: type)] = singleton
    }
    
    public static func resolve<T>() -> T {
        let key = String(describing: T.self)

        // Return singleton instance if it exists
        if let singleton = DIContainer.shared.singletons[key] as? T {
            return singleton
        }

        // Otherwise, create a new instance using the factory
        if let factory = DIContainer.shared.factories[key]?() as? T {
            return factory
        }

        fatalError("No registered entry for \(T.self)")
    }
    
}
