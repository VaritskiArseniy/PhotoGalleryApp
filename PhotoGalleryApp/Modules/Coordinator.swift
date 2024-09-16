//
//  Coordinator.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 11.09.24.
//

import Foundation
import UIKit

final class Coordinator {
    
    private let assembly: Assembly
    private var navigationController = UINavigationController()
    
    init(assembly: Assembly) {
        self.assembly = assembly
    }
    
    func startMain(window: UIWindow) {
        let mainViewController = assembly.makeMain(output: self)
        let favoriteViewController = assembly.makeFavorite(output: self)
        
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
        
        let tabs: [TabBarItem] = [
            .init(
                item: .init(
                    title: "Галерея",
                    image: UIImage(systemName: "photo.stack"),
                    tag: .zero),
                viewController: mainNavigationController
            ),
            .init(
                item: .init(
                    title: "Избранное",
                    image: UIImage(systemName: "heart"),
                    tag: 1),
                viewController: favoriteNavigationController
            )
        ]
        
        let viewController = assembly.makeTabbar(tabs: tabs)
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension Coordinator: MainOutput {
    func showDetails(for photo: PhotoModel) {
        let viewController = assembly.makeDetails(photo: photo)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension Coordinator: FavoriteOutput { 
    func showFavDetails(for photo: PhotoRealmModel) {
        let viewController = assembly.makeFavDetails(photo: photo)
        navigationController.pushViewController(viewController, animated: true)
    }
}
