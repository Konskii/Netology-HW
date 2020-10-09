//
//  PublishingViewController.swift
//  MultithreadingCourseWork
//
//  Created by Артём Скрипкин on 08.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class PublishingViewController: UIViewController {
    
    //MARK: - UI Elements
    
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
        field.backgroundColor = .lightGray
        field.layer.cornerRadius = 6
        field.layer.borderWidth = 1
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    ///Блокирующее вью, которое появляется при долгой работе с данными
    private lazy var blockView: BlockView = {
        let view = BlockView()
        return view
    }()
    
    //MARK: - Methods
    
    private func setupConstraints() {
        guard let tb = tabBarController else { fatalError("Not embbed with tabBarController") }
        
        view.addSubview(imageView)
        view.addSubview(addDescriptionLabel)
        view.addSubview(descriptionTextField)
        tb.view.addSubview(blockView)
        
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
            
            blockView.topAnchor.constraint(equalTo: tb.view.topAnchor),
            blockView.leadingAnchor.constraint(equalTo: tb.view.leadingAnchor),
            blockView.trailingAnchor.constraint(equalTo: tb.view.trailingAnchor),
            blockView.bottomAnchor.constraint(equalTo: tb.view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    ///Функция чтобы установить изображение
    public func setImage(image: UIImage?) {
        imageView.image = image
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextFunc))
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        view.addGestureRecognizer(tap)
    }
    
    
    //MARK: - User Interaction
    
    @objc func tapHandler() {
        view.endEditing(true)
    }
    
    @objc func nextFunc() {
        guard let image = imageView.image else { Alert.showBasic(vc: self); return }
        blockView.show()
        DataProviders.shared.postsDataProvider.newPost(with: image, description: descriptionTextField.text!, queue: DispatchQueue.global()) { (post) in
            guard post != nil else { Alert.showBasic(vc: self); return }
            DispatchQueue.main.async {
                self.blockView.hide()
                self.tabBarController?.selectedIndex = 0
            }
        }
        
    }
}
