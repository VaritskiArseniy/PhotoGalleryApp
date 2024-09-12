//
//  PhotoModel.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 11.09.24.
//

import Foundation
import UIKit

struct PhotoModel: Codable {
    let id: String
    let created_at: String
    let urls: PhotoURLs
    let user: User
    let location: Location?
    let downloads: Int?
}

struct PhotoURLs: Codable {
    let thumb: String
}
struct User: Codable {
    let name: String
}

struct Location: Codable {
    let city: String?
    let country: String?
}
