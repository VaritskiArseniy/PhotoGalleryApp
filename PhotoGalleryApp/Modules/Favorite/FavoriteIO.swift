//
//  FavoriteIO.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 12.09.24.
//

import Foundation

protocol FavoriteOutput: AnyObject { 
    func showFavDetails(for photo: PhotoRealmModel)
}
