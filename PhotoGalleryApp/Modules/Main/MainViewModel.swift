//
//  MainViewModel.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 11.09.24.
//

import Foundation

protocol MainViewModelInterface {

}

class MainViewModel {
    weak var view: MainViewControllerInterface?
    private weak var output: MainOutput?
    
    init(output: MainOutput) {
        self.output = output
    }

}

extension MainViewModel: MainViewModelInterface { }

