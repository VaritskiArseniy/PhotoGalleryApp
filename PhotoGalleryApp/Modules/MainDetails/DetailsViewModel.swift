//
//  DetailsViewModel.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 11.09.24.
//

import Foundation

protocol DetailsViewModelInterface {

}

class DetailsViewModel {
    weak var view: DetailsViewControllerInterface?
    private weak var output: DetailsOutput?
    
    init(output: DetailsOutput? = nil) {
        self.output = output
    }
    
}

extension DetailsViewModel: DetailsViewModelInterface { }

