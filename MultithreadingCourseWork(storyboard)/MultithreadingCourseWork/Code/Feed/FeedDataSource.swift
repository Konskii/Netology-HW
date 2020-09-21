//
//  FeedDataSource.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 06.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import DataProvider

fileprivate let postsData = DataProviders.shared.postsDataProvider
fileprivate let usersData = DataProviders.shared.usersDataProvider

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return feed.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? PostCell
            else { fatalError("ERROR 5") }
        
        let data = CellData(post: feed[indexPath.row], indexPath: indexPath)
        
        cell.configureCell(data)
        cell.delegate = self
        cell.delegateForProfile = self
        return cell
    }
}


