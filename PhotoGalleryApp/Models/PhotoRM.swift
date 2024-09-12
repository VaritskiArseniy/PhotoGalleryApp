//
//  PhotoRealmModel.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 12.09.24.
//

import Foundation
import RealmSwift

class PhotoRealmModel: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var createdAt: String
    @Persisted var imageData: Data?
    @Persisted var userName: String
    @Persisted var location: String?
    @Persisted var downloads: Int

    convenience init(photoModel: PhotoModel, imageData: Data?) {
        self.init()
        self.id = photoModel.id
        self.createdAt = photoModel.created_at
        self.imageData = imageData
        self.userName = photoModel.user.name
        self.location = photoModel.location?.city
        self.downloads = photoModel.downloads ?? 0
    }
}
