//
//  Assemply.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 11.09.24.
//

import Foundation
import UIKit

final class Assembly {
    
    let realmManager: RealmManagerProtocol = RealmManager()
    let apiManager: UnsplashAPIManagerProtocol = UnsplashAPIManager()
    
    func makeMain(output: MainOutput) -> UIViewController {
        let viewModel = MainViewModel(apiManager: apiManager, output: output)
        let view = MainViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func makeFavorite(output: FavoriteOutput) -> UIViewController {
        let viewModel = FavoriteViewModel(output: output, realmManager: realmManager)
        let view = FavoriteViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func makeDetails(photo: PhotoModel) -> UIViewController {
        let viewModel = DetailsViewModel(photo: photo, realmManager: realmManager)
        let view = DetailsViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }

    func makeFavDetails(photo: PhotoRealmModel) -> UIViewController {
        let viewModel = FavDetailsViewModel(photo: photo, realmManager: realmManager)
        let view = FavDetailsViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func makeTabbar(tabs: [TabBarItem]) -> UIViewController {
        let controller = UITabBarController()
        controller.navigationItem.hidesBackButton = true
        controller.tabBar.tintColor = .systemBlue
        controller.tabBar.backgroundColor = .white
        controller.viewControllers = tabs.compactMap {
            let vc = $0.viewController
            vc.tabBarItem = $0.item
            return vc
        }
        return controller
    }
}
