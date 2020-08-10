//
//  CellDetail.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 9/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation

class CellDetail: UserDetailsElementModel {
    
    var label: String! {
        didSet {
            if (self.label == StringConstants.noteLabel)
            {
                self.cellType = .noteCell
            }
        }
    }
    var value: String!
    var cellType: UserDetailsElementType = .detailCell
    
    internal init(label: String, value: String) {
        self.label = label
        self.value = value
        if (self.label == StringConstants.noteLabel)
        {
            self.cellType = .noteCell
        }
    }
}
