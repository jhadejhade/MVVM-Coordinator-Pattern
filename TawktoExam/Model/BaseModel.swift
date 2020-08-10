//
//  BaseModel.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 10/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation

class BaseModel {
    let id: Int!
    var note: String = ""
    
    init(id: Int, note: String) {
        self.id = id
        self.note = note
    }
}
