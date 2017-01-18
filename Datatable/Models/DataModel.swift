//
//  DataModel.swift
//  Datatable
//
//  Created by Dhaval Prajapati on 09/01/17.
//  Copyright © 2017 KC. All rights reserved.
//

import UIKit

class DataModel: NSObject {
    
    var title: String!
    var type: ColumnType?
    var sort: HeaderSort = .none
    var width: CGFloat = 0
    var height: CGFloat?
}
