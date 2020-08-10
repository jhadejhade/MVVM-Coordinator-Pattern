//
//  InformationTableViewCell.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 9/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import UIKit

class InformationTableViewCell: UITableViewCell, UserDetailsElementCell {

    @IBOutlet var cellLabel: UILabel!
    @IBOutlet var cellValue: UILabel!
    
    var textViewChanged: ((_ textView: UITextView) -> Void)?
       
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(model: UserDetailsElementModel) {
        guard let user = model as? CellDetail  else {
            print("error casting model as CellDetail: \(model)")
            return
        }
        cellLabel.text = user.label
        cellValue.text = user.value
    }
}
