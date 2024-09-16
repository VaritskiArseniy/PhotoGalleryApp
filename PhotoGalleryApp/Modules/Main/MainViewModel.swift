//
//  MainViewModel.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 11.09.24.
//

import Foundation

class MainViewModel {
    weak var view: MainViewControllerInterface?
    private weak var output: MainOutput?
    private let apiManager: UnsplashAPIManagerProtocol
    
    var photos: [PhotoModel] = [] {
        didSet {
            photosDidUpdate?(photos)
        }
    }

    var photosDidUpdate: (([PhotoModel]) -> Void)?
    var showError: ((String) -> Void)?
  
    init(apiManager: UnsplashAPIManagerProtocol, output: MainOutput?) {
        self.apiManager = apiManager
        self.output = output
    }
    
    func loadRandomPhotos() {
        apiManager.getRandomPhotos { [weak self] result in
            switch result {
            case .success(let photoModels):
                self?.photos = photoModels
            case .failure(let error):
                self?.showError?("Failed to load photos: \(error.localizedDescription)")
            }
        }
    }
    
    func searchPhotos(query: String) {
        apiManager.searchPhotos(query: query) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
            case .failure(let error):
                self?.showError?("Failed to search photos: \(error.localizedDescription)")
            }
        }
    }
    
    func showDetails(photo: PhotoModel) {
        output?.showDetails(for: photo)
    }
}
