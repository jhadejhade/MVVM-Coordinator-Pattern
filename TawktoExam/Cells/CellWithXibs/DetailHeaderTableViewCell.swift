//
//  DetailHeaderTableViewCell.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 9/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import UIKit

class DetailHeaderTableViewCell: UITableViewCell {

    @IBOutlet var followingLabel: UILabel!
    @IBOutlet var followersLabel: UILabel!
    @IBOutlet var headerImage: UIImageView!
    @IBOutlet var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func configure(userDetails: UserDetail?)
    {
        headerImage.setRoundView()
        //only set the data if userDetails is not not
        if let userDetails = userDetails
        {
            self.headerImage.load(placeholder: UIImage(systemName: "person.circle"), imgUrl: userDetails.avatarUrl!) { (image) in
            }
            self.backgroundImage.load(placeholder: UIImage(systemName: "person.circle"), imgUrl: userDetails.avatarUrl!) { (image) in
            }
            self.followersLabel.text = "Followers: \(userDetails.followers)"
            self.followingLabel.text = "Following: \(userDetails.following)"
        }
    }
}
