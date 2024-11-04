//
//  Injected.swift
//  
//
//  Created by Hanan on 04/02/2024.
//

import Foundation

@propertyWrapper
public struct Injected<T> {
    private var value: T

    public init() {
        self.value = DIContainer.resolve()
    }

   public var wrappedValue: T {
       get {
           value
       } set {
           value = newValue
       }
    }
}
