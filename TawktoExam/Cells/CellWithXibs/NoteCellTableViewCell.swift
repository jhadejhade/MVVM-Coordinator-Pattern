//
//  NoteCellTableViewCell.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 9/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import UIKit

///This will only be used when the data is from Core Data
class NoteCellTableViewCell: UITableViewCell, UserDetailsElementCell, UITextViewDelegate {
    
    @IBOutlet var cellNote: UITextView!
    @IBOutlet var cellLabel: UILabel!
    
    var cellDetails: CellDetail!
    var textViewChanged: ((_ textView: UITextView) -> Void)?
       
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellNote.delegate = self
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
        
        self.cellDetails = user
        cellLabel.text = user.label
        cellNote.text = user.value
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if (textView.text == StringConstants.notePlaceholder)
        {
            textView.text = ""
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if (textView.text == "")
        {
            textView.text = StringConstants.notePlaceholder
        }
        self.textViewChanged?(textView)
        return true
    }
}
