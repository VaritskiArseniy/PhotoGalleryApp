//
//  Assemply.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 11.09.24.
//

import Foundation
import UIKit

final class Assembly {
    
    func makeMain(output: MainOutput) -> UIViewController {
        let viewModel = MainViewModel(output: output)
        let view = MainViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }
    
    func makeFavorite(output: FavoriteOutput) -> UIViewController {
        let realmManager = RealmManager()
        let viewModel = FavoriteViewModel(output: output, realmManager: realmManager)
        let view = FavoriteViewController(viewModel: viewModel)
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
