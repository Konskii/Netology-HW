//
//  UserListTableViewController.swift
//  Course2FinalTask
//
//  Created by Артём Скрипкин on 05.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class UserListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    //MARK: - Variables
    
    private var usersToShow: [User] = []

    //MARK: - Making Controller Reusable
    convenience init(usersArray: [User]) {
        self.init()
        usersToShow = usersArray
    }
    
    override func viewDidLoad() {
        let tableView = UITableView(frame: self.view.frame)
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UsersListCell.self, forCellReuseIdentifier: "likesCell")
        
    }

    //MARK: - Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "likesCell", for: indexPath) as? UsersListCell else { fatalError("ERROR 3") }

        cell.configureCell(user: usersToShow[indexPath.row])
        
        return cell
    }
    
    //MARK: - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Storyboard", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { fatalError("ERROR 4") }
        vc.changeUserID(idToChange: usersToShow[indexPath.row].id)
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
