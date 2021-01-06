//
//  RepositoriesListCell.swift
//  networkFirstTask
//
//  Created by Артём Скрипкин on 10.11.2020.
//  Copyright © 2020 Артём Скрипкин. All rights reserved.
//

import UIKit

class RepositoriesListCell: UITableViewCell {
    //MARK: - Properties
    static let reusedID = "RepositoriesListCell"
    
    public var repoData: Repository? {
        didSet {
            guard let data = repoData else { return }
            self.repoName.text = data.name
            self.repoOwnerName.text = data.owner?.login
            repoOwnerName.sizeToFit()
            self.repoDescription.text = data.description
            guard let imageUrl = data.owner?.avatarURL else { return }
            self.repoImage.kf.setImage(with: imageUrl)
        }
    }
    
    //MARK: - UI Elements
    private lazy var repoImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var repoName: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var repoDescription: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var repoOwnerName: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Methods
    private func setupConstraints() {
        addSubview(repoName)
        addSubview(repoDescription)
        addSubview(repoOwnerName)
        addSubview(repoImage)
        
        let constraints = [
            repoName.topAnchor.constraint(equalTo: topAnchor),
            repoName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            repoName.trailingAnchor.constraint(equalTo: repoOwnerName.leadingAnchor, constant: -5),
            
            repoDescription.topAnchor.constraint(equalTo: repoName.bottomAnchor),
            repoDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            repoDescription.bottomAnchor.constraint(equalTo: bottomAnchor),
            repoDescription.trailingAnchor.constraint(equalTo: repoImage.leadingAnchor),
        
            repoOwnerName.topAnchor.constraint(equalTo: topAnchor),
            repoOwnerName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            
            repoImage.topAnchor.constraint(equalTo: repoOwnerName.bottomAnchor, constant: 2),
            repoImage.heightAnchor.constraint(equalToConstant: bounds.height - repoOwnerName.bounds.height),
            repoImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            repoImage.widthAnchor.constraint(equalTo: repoImage.heightAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
