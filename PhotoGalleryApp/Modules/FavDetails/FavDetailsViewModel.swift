//
//  FavDetailsViewModel.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 12.09.24.
//

import Foundation

protocol FavDetailsViewModelInterface {

}

class FavDetailsViewModel {
    weak var view: FavDetailsViewControllerInterface?
    private let realmManager: RealmManagerProtocol
    var photo: PhotoRealmModel
    
    init(photo: PhotoRealmModel, realmManager: RealmManagerProtocol) {
        self.photo = photo
        self.realmManager = realmManager
    }
    
    func deletePhoto(_ photo: PhotoRealmModel) {
        realmManager.delete(photo)
    }
}

extension FavDetailsViewModel: FavDetailsViewModelInterface { }
