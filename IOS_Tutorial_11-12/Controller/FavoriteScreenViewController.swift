//
//  FavoriteScreenViewController.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thai on 23/12/2022.
//

import UIKit
import CoreData

final class FavoriteScreenViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var users = [UserModel]()
    private let coreData = CoreData.shared
    
    private var favoriteUsers = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreData.getListUsers() { items, error in
            guard error == nil else {
                print("Could not fetch. \(String(describing: error))")
                return
            }
            self.users = items.map{
                self.changeNSManagedObjectToUserModel(nsManagedObject: $0)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func changeNSManagedObjectToUserModel (nsManagedObject: NSManagedObject) -> UserModel {
        let user = UserModel(
            login: nsManagedObject.value(forKey: "login") as? String ?? "",
            id: nsManagedObject.value(forKey: "id") as? Int ?? 0,
            avatarUrl: nsManagedObject.value(forKey: "avatarUrl") as? String ?? "",
            url: nsManagedObject.value(forKey: "url") as? String ?? "",
            htmlUrl: nsManagedObject.value(forKey: "htmlUrl") as? String ?? "",
            followersUrl: nsManagedObject.value(forKey: "followersUrl") as? String ?? "",
            followingUrl: nsManagedObject.value(forKey: "followingUrl") as? String ?? "",
            reposUrl: nsManagedObject.value(forKey: "reposUrl") as? String ?? ""
        )
        return user
    }

}

extension FavoriteScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserTableViewCell.self)
        cell.bindData(user: users[indexPath.row])
        return cell
    }
}

extension FavoriteScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailScreen = storyBoard.instantiateViewController(withIdentifier: "DetailUserScreenViewController") as? DetailUserScreenViewController
        detailScreen?.bindData(user: users[indexPath.row])
        self.navigationController?.pushViewController(detailScreen!, animated: true)
    }
}
