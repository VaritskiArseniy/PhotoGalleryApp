//
//  MainIO.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 11.09.24.
//

import Foundation

protocol MainOutput: AnyObject { 
    func showDetails(for photo: PhotoModel)
}
