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
    private weak var output: FavDetailsOutput?
    
    init(output: FavDetailsOutput? = nil) {
        self.output = output
    }
}

extension FavDetailsViewModel: FavDetailsViewModelInterface { }
