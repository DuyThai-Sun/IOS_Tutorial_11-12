//
//  UserTableViewCell.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thái on 20/12/2022.
//

import UIKit

protocol ReusableTableViewCell: AnyObject {
    static var defaultReuseIdentifier: String { get }
    static var nibName: String { get }
}

final class UserTableViewCell: UITableViewCell, ReusableTableViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var linkGitTextView: UITextView!
    @IBOutlet private weak var userImageView: UIImageView!
    private let callAPI = APICaller.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView ()
    }
    
    private func configView () {
        congfigBackView()
        userImageView.circleView()
        linkGitTextView.textContainer.maximumNumberOfLines = 1
    }
    
    func bindData(user: User) {
        self.callAPI.getImage(imageURL: (user.avatarUrl)) { [weak self] (data, error)  in
            guard let self = self else { return }
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.userImageView.image = UIImage(data: data)
                }
            }
        }
        userNameLabel.text = user.login
        linkGitTextView.text = user.htmlUrl
    }
    
    private func congfigBackView() {
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor(#colorLiteral(red: 0.6516604424, green: 0.6652742028, blue: 0.6650359035, alpha: 0.8470588235)).cgColor
        containerView.layer.cornerRadius = 12
        containerView.dropShadow(color: UIColor.black.cgColor, opacity: 1, cornerRadius: 12, offSet: CGSize(width: 0 , height: 2))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
