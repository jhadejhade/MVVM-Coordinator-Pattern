//
//  NormalUserTableViewCell.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 7/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import UIKit

class NormalUserTableViewCell: UITableViewCell, UsersElementCell {
    
    var user: User!
    
    var avatar: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var detailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(avatar)
        addSubview(nameLabel)
        addSubview(detailsLabel)
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: Name Label Constraint
        NSLayoutConstraint.activate([nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                                     nameLabel.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 8),
                                     nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 8)])
        
        // MARK: Details Label Constraint
        NSLayoutConstraint.activate([detailsLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 0),
                                     detailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                                     detailsLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 0),
                                     detailsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)])
        
        // MARK: Avatar Constraint
        NSLayoutConstraint.activate([ avatar.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 0),
                                      avatar.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
                                      NSLayoutConstraint(item: avatar, attribute: .height, relatedBy: .equal, toItem: avatar, attribute: .width, multiplier: 1, constant: 0),
                                      NSLayoutConstraint(item: avatar, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.15, constant: 0)])
        
    }
    
    func configure(model: UsersElementModel) {
        guard let user = model as? User  else {
            print("error casting model as User: \(model)")
            return
        }
        
        self.user = user
        
        nameLabel.text = user.name
        detailsLabel.text = user.type
        avatar.load(placeholder: UIImage(systemName: "person.circle"), imgUrl: user.avatarUrl) { (image) in }
        
        if (user.seen)
        {
            self.backgroundColor = .lightGray
        } else {
            self.backgroundColor = .white
        }
    }
    
    override func draw(_ rect: CGRect) {
        // we put this here to make sure we get the right dimensions and achieve a perfect circle
        avatar.setRoundView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
