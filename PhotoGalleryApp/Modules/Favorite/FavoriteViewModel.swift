//
//  FavoriteViewModel.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 12.09.24.
//

import Foundation

protocol FavoriteViewModelInterface {

}

class FavoriteViewModel {
    weak var view: FavoriteViewControllerInterface?
    private weak var output: FavoriteOutput?
    private let realmManager: RealmManagerProtocol
    
    init(output: FavoriteOutput, realmManager: RealmManagerProtocol) {
        self.output = output
        self.realmManager = realmManager
    }
    
    func fetchFavorites() -> [PhotoRealmModel] {
        let photos = realmManager.fetchCollection(PhotoRealmModel.self)
        return Array(photos)
    }
}

extension FavoriteViewModel: FavoriteViewModelInterface { }
