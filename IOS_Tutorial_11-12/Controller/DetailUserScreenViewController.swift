//
//  DetailUserScreenViewController.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thai on 21/12/2022.
//

import UIKit

final class DetailUserScreenViewController: UIViewController {
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet private weak var nameAndAddressLabel: UILabel!
    @IBOutlet private weak var bioLabel: UILabel!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var followingButton: UIButton!
    @IBOutlet private weak var followerButton: UIButton!
    @IBOutlet private weak var numberRespositoryLabel: UILabel!
    @IBOutlet private weak var numberFollowingLabel: UILabel!
    @IBOutlet private weak var numberFollowerLabel: UILabel!
    @IBOutlet private weak var containInformView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    private var followerButtonIsSelected = true
    private let callAPI = APICaller.shared
    private var userRepository = UserRepository()
    private var followers = [UserModel]()
    private var following = [UserModel]()
    private var isFavorited = false
    private let coreData = CoreData.shared
    private var user: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        userImageView.circleView()
        favoriteButton.circleView()
        containInformView.layer.cornerRadius = 40
        configFollowerAndFollowingButton()
    }
    
    func bindData (user: UserModel) {
        self.callAPI.getImage(imageURL: (user.avatarUrl)) { [weak self] (data, error)  in
            guard let self = self else { return }
            if let _ = error {
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.userImageView.image = UIImage(data: data)
                }
            }
        }
        self.user = user
        self.updateUser(name: user.login)
        self.getDataFollowerAndFollowing(name: user.login)
        DispatchQueue.main.async {
            self.checkUserIsFavorited(user: user)
        }
        
    }
    
    private func checkUserIsFavorited(user: UserModel) {
        if coreData.checkUserInCoreData(informUser: user) {
            self.favoriteButton.backgroundColor = .systemPink
            self.isFavorited = true
        } else {
            self.favoriteButton.backgroundColor = UIColor(#colorLiteral(red: 0.9670718312, green: 0.5393305421, blue: 0.03985216469, alpha: 1))
            self.isFavorited = false
        }
    }
    
    private func updateUser (name: String) {
        userRepository.getDataUser(name: name) {  [weak self] (data, error) in
            guard let self = self else { return }
            if let _ = error {
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.upadateLabel(data: data)
                }
          }
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        configFavoriteButton()
    }
    
    private func configFavoriteButton() {
        if isFavorited {
            coreData.deleteUser(user: user)
            favoriteButton.backgroundColor = UIColor(#colorLiteral(red: 0.9670718312, green: 0.5393305421, blue: 0.03985216469, alpha: 1))
            isFavorited = false
        } else {
            coreData.addUser(informUser: user)
            favoriteButton.backgroundColor = .systemPink
            isFavorited = true
        }
    }
    
    private func upadateLabel(data: UserDetail) {
        self.nameAndAddressLabel.text = "\(data.name ?? "no name")*\(data.location ?? "")"
        self.numberFollowerLabel.text = "\(data.followers ?? 0)"
        self.numberFollowingLabel.text = "\(data.following ?? 0)"
        self.numberRespositoryLabel.text = "\(data.publicRepos ?? 0)"
        self.bioLabel.text = "\(data.bio ?? "no bio")"
    }
    
    private func getDataFollowerAndFollowing(name: String) {
        userRepository.getFollowers(name: name) { [weak self] (data, error) in
            guard let self = self else { return }
            if let _ = error {
                return
            }
            if let data = data {
                self.followers = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        userRepository.getFollowing(name: name) { [weak self] (data, error) in
            guard let self = self else { return }
            if let _ = error {
                return
            }
            if let data = data {
                self.following = data
            }
        }
    }
    
    private func configFollowerAndFollowingButton() {
        followerButton.topCornerRadius(cornerRadius: 10)
        followingButton.topCornerRadius(cornerRadius: 10)
        if followerButtonIsSelected {
            followerButton.backgroundColor = .white
            followerButton.tintColor = UIColor(#colorLiteral(red: 0.2822310925, green: 0.3429890871, blue: 0.3248010278, alpha: 1))
            followingButton.backgroundColor = UIColor(#colorLiteral(red: 0.2822310925, green: 0.3429890871, blue: 0.3248010278, alpha: 1))
            followingButton.tintColor = .white
        } else {
            followingButton.backgroundColor = .white
            followingButton.tintColor = UIColor(#colorLiteral(red: 0.2822310925, green: 0.3429890871, blue: 0.3248010278, alpha: 1))
            followerButton.backgroundColor = UIColor(#colorLiteral(red: 0.2822310925, green: 0.3429890871, blue: 0.3248010278, alpha: 1))
            followerButton.tintColor = .white
        }
    }
    
    @IBAction private func followerButtonTapped(_ sender: Any) {
        if !followerButtonIsSelected {
            followerButtonIsSelected = true
            configFollowerAndFollowingButton()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction private func FollowingButtonTapped(_ sender: Any) {
        if followerButtonIsSelected {
            followerButtonIsSelected = false
            configFollowerAndFollowingButton()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension DetailUserScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followerButtonIsSelected ? followers.count : following.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserTableViewCell.self)
        followerButtonIsSelected ? cell.bindData(user: followers[indexPath.row]) : cell.bindData(user: following[indexPath.row])
        return cell
    }
}

extension DetailUserScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailScreen = storyBoard.instantiateViewController(withIdentifier: "DetailUserScreenViewController") as? DetailUserScreenViewController
        followerButtonIsSelected ? detailScreen?.bindData(user: followers[indexPath.row]) :             detailScreen?.bindData(user: following[indexPath.row])
        self.navigationController?.pushViewController(detailScreen!, animated: true)
    }
}
