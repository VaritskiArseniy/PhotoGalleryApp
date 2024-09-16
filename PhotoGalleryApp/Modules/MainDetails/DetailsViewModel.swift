//
//  DetailsViewModel.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 11.09.24.
//

import Foundation
import UIKit

class DetailsViewModel {
    weak var view: DetailsViewControllerInterface?
    private let realmManager: RealmManagerProtocol
    var photo: PhotoModel
    
    private enum Constants {
        static var alertTitle = { "Добавленно в избранное" }
        static var alertMassage = { "Понравившиеся изображения можно просматреть в разделе избранное" }
        static var alertDoneTitle = { "Уже есть в избранном" }
    }
    
    init(photo: PhotoModel, realmManager: RealmManagerProtocol) {
        self.photo = photo
        self.realmManager = realmManager
    }

    func doesPhotoExist(with photoModel: PhotoModel) -> Bool {
        return realmManager.doesPhotoExist(with: photoModel.id)
    }
        
    func addFavourite(with photoModel: PhotoModel, imageUrl: URL) {
        DispatchQueue.global().async {
            if let imageData = try? Data(contentsOf: imageUrl) {
                let photoRealmModel = PhotoRealmModel(photoModel: photoModel, imageData: imageData)
                
                DispatchQueue.main.async {
                    self.realmManager.create(photoRealmModel)
                }
            } else {
                print("Ошибка загрузки изображения")
            }
        }
    }
}
