//
//  DetailsViewController.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 11.09.24.
//

import UIKit
import RealmSwift

protocol DetailsViewControllerInterface: AnyObject { }

class DetailsViewController: UIViewController {
    
    private var viewModel: DetailsViewModel
    let realmManager = RealmManager()
    
    var photoModel: PhotoModel?
    
    private enum Constants {
        static var cellIdentifier = { "cellIdentifier" }
        static var alertTitle = { "Добавленно в избранное" }
        static var alertMassage = { "Понравившиеся изображения можно просматреть в разделе избранное" }
        static var alertDoneTitle = { "Уже есть в избранном" }
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
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.addImage(), for: .normal)
        button.addTarget(self, action: #selector(addButtonPress), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        configureView(with: viewModel.photo)
        navigationController?.navigationBar.isHidden = false
    }
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        configureView(with: viewModel.photo)
        view.addSubviews([tableView, addButton])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 100),
            addButton.heightAnchor.constraint(equalToConstant: 100),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    
    private func configureView(with photo: PhotoModel) {
        self.photoModel = photo
        tableView.reloadData()
    }
    
    @objc
    private func addButtonPress() {
        guard let photoModel = photoModel else {
            print("photoModel is nil")
            return
        }
        
        guard let imageUrl = URL(string: photoModel.urls.thumb) else {
            print("Invalid URL")
            return
        }
        
        if viewModel.doesPhotoExist(with: photoModel) {
            print("This photo is already added to favorites.")
            let alertController = UIAlertController(
                title: Constants.alertDoneTitle(),
                message: .none,
                preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }
        
        viewModel.addFavourite(with: photoModel, imageUrl: imageUrl)
        
        let alertController = UIAlertController(
            title: Constants.alertTitle(),
            message: Constants.alertMassage(),
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        if let urlString = photoModel?.urls.thumb, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
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
            cell.configure(title: photoModel?.user.name ?? "???")
            
        case 1:
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "dd.MM.yyyy"
            
            guard let oldDate = photoModel?.created_at else { return UITableViewCell() }
            
            if let date = inputDateFormatter.date(from: oldDate) {
                let formattedDateString = outputDateFormatter.string(from: date)
                cell.configure(title: formattedDateString )
            } else {
                print("Ошибка преобразования даты")
            }
            
        case 2:
            cell.configure(title:  photoModel?.location?.city ?? "unknown location")
            
        case 3:
            guard let downloads = photoModel?.downloads else { return UITableViewCell() }
            cell.configure(title: String(downloads))
            
        default:
            return cell
        }
        
        return cell
        
    }
}

extension DetailsViewController: DetailsViewControllerInterface { }
