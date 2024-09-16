//
//  RealmManager.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 12.09.24.
//

import Foundation
import RealmSwift

protocol RealmManagerProtocol {
    func create(_ object: Object)
    func delete(_ object: Object)
    func write(completion: () -> Void)
    func fetchCollection<T: Object>(_ type: T.Type) -> Results<T>
    func doesPhotoExist(with id: String) -> Bool
}

final class RealmManager {
    private let realm: Realm

    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
}

extension RealmManager: RealmManagerProtocol {
    func create(_ object: Object) {
        try? realm.write {
            realm.add(object)
        }
    }
    
    func write(completion: () -> Void) {
        try? realm.write {
            completion()
        }
    }
    
    func fetchCollection<T: Object>(_ type: T.Type) -> Results<T> {
        realm.objects(type)
    }
    
    func delete(_ object: Object) {
        try? realm.write {
            realm.delete(object)
        }
    }
    
    func doesPhotoExist(with id: String) -> Bool {
        return realm.object(ofType: PhotoRealmModel.self, forPrimaryKey: id) != nil
    }
}
