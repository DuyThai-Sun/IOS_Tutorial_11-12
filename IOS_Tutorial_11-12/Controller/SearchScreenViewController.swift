//
//  SearchViewController.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thái on 20/12/2022.
//

import UIKit
final class SearchScreenViewController: UIViewController {
    @IBOutlet private weak var userSearchBar: UISearchBar!
    @IBOutlet private weak var iconHeartButton: UIButton!
    @IBOutlet private weak var listUserTableView: UITableView!
    
    private var userRepository = UserRepository()
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers(name: "abc")
        congfigView()
    }
    
    private func congfigView() {
        congfigSearchBar()
    }
    
    private func getUsers(name: String) {
        userRepository.getUsersByName(name: name) { [weak self] (data, error) in
            guard let self = self else { return }
            if let _ = error {
                return
            }
            if let data = data {
                self.users = data
                DispatchQueue.main.async {
                    self.listUserTableView.reloadData()
                }
            }
        }
    }
    
    private func congfigSearchBar() {
        userSearchBar.searchTextField.backgroundColor = .white
        userSearchBar.setImage(UIImage(systemName: "person.circle.fill"), for: .search, state: .normal)
        userSearchBar.setImage(UIImage(systemName: "xmark.circle.fill"), for: .clear, state: .normal)
    }
}

extension SearchScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserTableViewCell.self)
        cell.bindData(user: users[indexPath.row])
        return cell
    }
}
