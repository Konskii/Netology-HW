//
//  CreateNewPostViewController.swift
//  NetworkCourseWork
//
//  Created by Артём Скрипкин on 30.01.2021.
//

import UIKit

class CreateNewPostViewController: UIViewController {
    ///Предпросмотр с картинкой которая будет в посте
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.image = UIImage(named: "indicator")
        return view
    }()
    
    ///Лейбл с текстом "Add description"
    private lazy var addDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Add description"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    ///Текстфилд куда вводится описание
    private lazy var descriptionTextField: UITextField = {
        let field = UITextField()
        field.layer.cornerRadius = 6
        field.layer.borderWidth = 1
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let networkManager = NetworkManager()
    
    //MARK: - Methods
    
    private func setupConstraints() {
        
        view.addSubview(imageView)
        view.addSubview(addDescriptionLabel)
        view.addSubview(descriptionTextField)
        
        let constraints = [
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            addDescriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            addDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            descriptionTextField.topAnchor.constraint(equalTo: addDescriptionLabel.bottomAnchor, constant: 8),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareTapped))
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        view.addGestureRecognizer(tap)
        navigationItem.title = "Create post"
    }
    
    convenience init(image: UIImage?) {
        self.init()
        imageView.image = image
    }
    
    
    //MARK: - User Interaction
    
    @objc func tapHandler() {
        view.endEditing(true)
    }
    
    @objc func shareTapped() {
        guard let stringImage = imageView.image?.jpegData(compressionQuality: 1)?.base64EncodedString() else { return }
        guard let description = descriptionTextField.text else { return }
        networkManager.createPost(image: stringImage, description: description) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.showAlert(title: "Success!", message: "Post created successfully.")
            case .failure(let error):
                self.showAlert(title: "Error!", message: "\(error)")
            }
        }
    }
}
