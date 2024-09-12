//
//  MainCollectionViewCell.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 11.09.24.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.hidesWhenStopped = true
            return activityIndicator
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubviews([imageView, activityIndicator])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
             activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
             activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
         ])
    }
    
    func configure(with photo: PhotoModel) {
        guard let url = URL(string: photo.urls.thumb) else {
            imageView.image = nil
            return
        }
        
        activityIndicator.startAnimating()
        
        imageView.kf.setImage(with: url, placeholder: nil, options: nil, completionHandler: { [weak self] result in
            self?.activityIndicator.stopAnimating()
        })
    }
}
