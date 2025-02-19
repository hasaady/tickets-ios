//
// DbContext.swift
// CoreDb
//
// Created by Hanan on 27/10/2024.
//

import Foundation
import RealmSwift

public typealias Presistable = Object

public protocol DbContext {
    
    func save<T: Presistable>(_ object: T) async throws
    
    func save<T: Presistable>(_ object: [T]) async throws
    
    func replace<T: Presistable>(_ objects: [T]) async throws
    
    func update<T: Presistable>(object: T, _ block: @escaping (T?) -> Void) async throws
    
    func update<T: Presistable>(objects: [T], _ block: @escaping ([T]) -> Void) async throws
    
    func delete<T: Presistable>(_ object: T) async throws
    
    func deleteAll<T: Presistable>(_ type: T.Type) async throws
    
    func fetch<T: Presistable>(_ type: T.Type) throws -> [T]
    
    func fetchFirst<T: Presistable>(_ type: T.Type) throws -> T?
    
    func fetch<T: Presistable>(with predicate: NSPredicate, _ type: T.Type) throws -> [T]
    
    func fetchFirst<T: Presistable>(with predicate: NSPredicate, _ type: T.Type) throws -> T?
}

enum DbError: Error {
    case dbNotInitialized
}

@globalActor actor DatabaseActor: GlobalActor {
    static var shared = DatabaseActor()
}

actor DbContextImp: DbContext {
    
    public init() {}
    
    public func save<T: Presistable>(_ object: T) async throws {
        let realm = try await Realm(actor: self)
        
        let resolvedObject = object.threadSafeCopy()
        
        try await realm.asyncWrite {
            if let resolvedObject = resolvedObject {
                realm.add(resolvedObject, update: .modified)
            }
        }
    }
    
    public func save<T: Presistable>(_ objects: [T]) async throws {
        let realm = try await Realm(actor: self)
        
        let resolvedObjects = objects.compactMap { $0.threadSafeCopy() }
        
        try await realm.asyncWrite {
            resolvedObjects.forEach { resolvedObject in
                realm.create(
                    type(of: resolvedObject),
                    value: resolvedObject,
                    update: .modified
                )
            }
        }
    }
    
    public func replace<T: Presistable>(_ objects: [T]) async throws {
        let realm = try await Realm(actor: self)
        
        let resolvedObjects = objects.compactMap { $0.threadSafeCopy() }
        
        try await realm.asyncWrite {
            
            let deletedObjects = realm.objects(T.self)
            realm.delete(deletedObjects)
            
            realm.add(resolvedObjects, update: .modified)
        }
    }
    
    public func update<T: Presistable>(object: T, _ block: @escaping (T?) -> Void) async throws {
        let realm = try await Realm(actor: self)
        
        let reference = ThreadSafeReference(to: object)
        
        try await realm.asyncWrite {
            let resolvedObject = realm.resolve(reference)
            block(resolvedObject)
        }
    }
    
    public func update<T: Presistable>(objects: [T], _ block: @escaping ([T]) -> Void) async throws {
        let realm = try await Realm(actor: self)
        
        let references = objects.map { ThreadSafeReference(to: $0) }
        
        try await realm.asyncWrite {
            let resolvedObjects = references.compactMap { realm.resolve($0) }
            
            block(resolvedObjects)
        }
    }
    
    public func delete<T: Presistable>(_ object: T) async throws {
        let realm = try await Realm(actor: self)
        
        try await realm.asyncWrite {
            realm.delete(object)
        }
    }
    
    public func deleteAll<T: Presistable>(_ type: T.Type) async throws {
        let realm = try await Realm(actor: self)
        
        try await realm.asyncWrite {
            let objects = realm.objects(type)
            realm.delete(objects)
        }
    }
    
    nonisolated public func fetch<T: Presistable>(_ type: T.Type) throws -> [T] {
        let realm = try Realm()
        let results = realm.objects(type)
        return Array(results)
    }
    
    
    nonisolated public func fetchFirst<T: Presistable>(_ type: T.Type) throws -> T? {
        let realm = try Realm()
        return realm.objects(type).first
    }
    
    nonisolated public func fetch<T: Presistable>(with predicate: NSPredicate, _ type: T.Type) throws -> [T] {
        let realm = try Realm()
        let results = realm.objects(type).filter(predicate)
        return Array(results)
    }
    
    nonisolated public func fetchFirst<T: Presistable>(with predicate: NSPredicate, _ type: T.Type) throws -> T? {
        let realm = try Realm()
        return realm.objects(type).filter(predicate).first
    }
}

extension Object {
    func threadSafeCopy() -> Self? {
        
        guard let _ = self.realm else {
            return self
        }
        
        let threadSafeReference = ThreadSafeReference(to: self)
        do {
            
            let resolvedRealm = try Realm()
            guard let resolvedObject = resolvedRealm.resolve(threadSafeReference) else {
                print("Failed to resolve ThreadSafeReference.")
                
                return nil
            }
            return resolvedObject
            
        } catch {
            print("Error accessing Realm instance: \(error)")
            return nil
        }
    }
}
