//
//  ViewController.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 11.09.24.
//

import UIKit
import Kingfisher

protocol MainViewControllerInterface: AnyObject { }

class MainViewController: UIViewController {
    
    private var viewModel: MainViewModel
        
    private enum Constants {
        static var cellIndificator = { "cellIndificator" }
        static var alertTitle = { "Error" }
    }
    
    private var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let searchBar = UISearchBar()
    private var photos: [PhotoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        bindViewModel()
        getErrorMessage()
        viewModel.loadRandomPhotos()
        setupSearchBar()
        setupCollectionView()
        registerForKeyboardNotification()
        view.addSubviews([searchBar, mainCollectionView])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.photosDidUpdate = { [weak self] photosVM in
            self?.photos = photosVM
            DispatchQueue.main.async {
                self?.mainCollectionView.reloadData()
            }
        }
    }
    
    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
    }
    
    private func registerForKeyboardNotification() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutsideKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    private func tapOutsideKeyboard() {
            view.endEditing(true)
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero  
        mainCollectionView.collectionViewLayout = layout
        
        mainCollectionView.register(
            MainCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.cellIndificator()
        )
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.isScrollEnabled = true
        mainCollectionView.collectionViewLayout = createLayout()
    }
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil}
            return self.createMainSection()
        }
    }
    
    private func createLayoutSection(
        group: NSCollectionLayoutGroup,
        behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
        interGroupSpacing: CGFloat,
        supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem]
    ) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = behavior
        section.interGroupSpacing = interGroupSpacing
        section.boundarySupplementaryItems = supplementaryItems
        return section
    }
    
    private func createMainSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/2),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(200)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = createLayoutSection(
            group: group,
            behavior: .none,
            interGroupSpacing: 8,
            supplementaryItems: []
        )
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        return section
    }
    
    private func getErrorMessage() {
        viewModel.showError = { [weak self] errorMessage in
            self?.showAlert(message: errorMessage)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: Constants.alertTitle(), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.cellIndificator(),
            for: indexPath
        ) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
        let photo = photos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPhoto = photos[indexPath.item]
        
        viewModel.showDetails(photo: selectedPhoto)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        
        searchBar.resignFirstResponder()
        viewModel.searchPhotos(query: query)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.loadRandomPhotos()
        }
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if searchBar.isFirstResponder {
            return true
        }
        
        return false
    }
}

extension MainViewController: MainViewControllerInterface { }
