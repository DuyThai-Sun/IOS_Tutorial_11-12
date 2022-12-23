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
    @IBOutlet private weak var tableView: UITableView!
    
    private var userRepository = UserRepository()
    private var users = [UserModel]()
    private var oldTextSearch = ""
    private var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getUsers(name: "abc")
        congfigView()
    }
    
    @IBAction private func iconHeartButtonTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let favoriteScreen = storyBoard.instantiateViewController(withIdentifier: "FavoriteScreenViewController") as? FavoriteScreenViewController
        favoriteScreen?.title = "Favorite"
        self.navigationController?.pushViewController(favoriteScreen!, animated: true)
    }
    
    private func congfigView() {
        title = "Search User"
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
                    self.tableView.reloadData()
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

extension SearchScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var query = searchText
        query = query.removeWhitespace()
        if query.isEmpty {
            self.getUsers(name: self.oldTextSearch)
        } else {
            if query.trimmingCharacters(in: .whitespaces).count >= 3 {
                self.oldTextSearch = query
                timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (timer) in
                    self.getUsers(name: query)
                })
            }
        }
    }
}

extension SearchScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailScreen = storyBoard.instantiateViewController(withIdentifier: "DetailUserScreenViewController") as? DetailUserScreenViewController
        detailScreen?.bindData(user: users[indexPath.row])
        self.navigationController?.pushViewController(detailScreen!, animated: true)

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.userSearchBar.endEditing(true)
    }
}
