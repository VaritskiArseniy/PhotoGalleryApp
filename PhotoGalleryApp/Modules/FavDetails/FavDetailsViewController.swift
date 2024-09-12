//
//  FavDetailsViewController.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 12.09.24.
//

import UIKit

protocol FavDetailsViewControllerInterface: AnyObject { }

class FavDetailsViewController: UIViewController {
    
    private var viewModel: FavDetailsViewModel
    let realmManager = RealmManager()
    
    var photoModel: PhotoRealmModel?
    
    private enum Constants {
        static var cellIdentifier = { "cellIdentifier" }
        static var alertTitle = { "Добавленно в избранное" }
        static var alertMassage = { "Понравившиеся изображения можно просматреть в разделе избранное" }
        static var addImage = { R.image.likeImage() }
        static var deleteImage = { R.image.trashImage() }
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.register(
            DetailsTableViewCell.self,
            forCellReuseIdentifier: Constants.cellIdentifier()
        )
        table.dataSource = self
        table.delegate = self
        table.isUserInteractionEnabled = false
        table.separatorStyle = .singleLine
        table.allowsSelectionDuringEditing = false
        return table
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var deleteButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.deleteImage(), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonPress), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        tableView.reloadData()
    }
    
    init(viewModel: FavDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        tableView.reloadData()
        view.addSubviews([tableView, deleteButton])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 100),
            deleteButton.heightAnchor.constraint(equalToConstant: 100),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc
    private func deleteButtonPress() {
        guard let deletedModel = photoModel else {
            return
        }
        
        realmManager.delete(deletedModel)
        navigationController?.popViewController(animated: true)
    }
}

extension FavDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 350),
            imageView.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        if let imageData = photoModel?.imageData, let image = UIImage(data: imageData) {
            imageView.image = image
        } else {
            imageView.image = nil
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.cellIdentifier(),
            for: indexPath
        ) as? DetailsTableViewCell else { return UITableViewCell() }
        
        switch indexPath.item {
        case 0:
            cell.configure(title: photoModel?.userName ?? "???")
            
        case 1:
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "dd.MM.yyyy"
            
            guard let oldDate = photoModel?.createdAt else { return UITableViewCell() }
            
            if let date = inputDateFormatter.date(from: oldDate) {
                let formattedDateString = outputDateFormatter.string(from: date)
                cell.configure(title: formattedDateString )
            } else {
                print("Ошибка преобразования даты")
            }
            
        case 2:
            cell.configure(title:  photoModel?.location ?? "unknown location")
            
        case 3:
            guard let downloads = photoModel?.downloads else { return UITableViewCell() }
            cell.configure(title: String(downloads))
            
        default:
            return cell
        }
        
        return cell
    }
}

extension FavDetailsViewController: FavDetailsViewControllerInterface { }
