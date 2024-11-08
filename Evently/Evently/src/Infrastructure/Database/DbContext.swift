//
//  DbContext.swift
//  Evently
//
//  Created by Hanan on 27/10/2024.
//

import Foundation
import RealmSwift

typealias Presistable = Object

protocol DbContext {

    func add<T: Presistable>(_ object: T) async throws
   
    func add<T: Presistable>(_ object: [T]) async throws
    
    func replace<T: Presistable>(_ objects: [T]) async throws

    func objectsCount<T: Presistable>(_ type: T.Type) -> Int

    func update(_ block: @escaping (Realm) -> Void) async throws

    func delete<T: Presistable>(_ object: T) async throws

    func deleteAll<T: Presistable>(_ type: T.Type) async throws

    func fetchAll<T: Presistable>(_ type: T.Type) async throws -> Results<T>

    func fetch<T: Presistable>(with predicate: NSPredicate, _ type: T.Type) async throws -> Results<T>
}

enum DbError: Error {
    case dbNotInitialized
}

@globalActor fileprivate actor DatabaseActor: GlobalActor {
    static var shared = DatabaseActor()
}

actor DbContextImp: @preconcurrency DbContext {
   
    var realm: Realm!
   
    init() {
        Task {
            await initializeRealm()
        }
    }

    private func initializeRealm() async {
        do {
            self.realm = try await Realm(actor: DatabaseActor.shared)
            print("Realm is located at:", realm.configuration.fileURL!)
            
        } catch {
            debugPrint("Error initializing Realm: \(error)")
        }
    }
    
    func objectsCount<T: Presistable>(_ type: T.Type) -> Int {
        realm.objects(type).count
    }

    func add<T: Presistable>(_ object: T) async throws {
        try await realm.asyncWrite {
            realm.add(object, update: .modified)
        }
    }
    
    func add<T: Presistable>(_ objects: [T]) async throws {
        try await realm.asyncWrite {
            realm.add(objects, update: .modified)
        }
    }

    func replace<T: Presistable>(_ objects: [T]) async throws {
        try await realm.asyncWrite {
            let deletedObjects = realm.objects(T.self)
            realm.delete(deletedObjects)
            
            realm.add(objects)
        }
    }

    func update(_ block: @escaping (Realm) -> Void) async throws {
        try await realm.asyncWrite {
            block(realm)
        }
    }

    func delete<T: Presistable>(_ object: T) async throws {
        try await realm.asyncWrite {
            realm.delete(object)
        }
    }

    func deleteAll<T: Presistable>(_ type: T.Type) async throws {
        try await realm.asyncWrite {
            let objects = realm.objects(type)
            realm.delete(objects)
        }
    }

    func fetchAll<T: Presistable>(_ type: T.Type) async throws -> Results<T> {
        return realm.objects(type)
    }

    func fetch<T: Presistable>(with predicate: NSPredicate, _ type: T.Type) async throws -> Results<T> {
        return realm.objects(type).filter(predicate)
    }
    
}
