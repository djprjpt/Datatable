//
//  ViewController.swift
//  Datatable
//
//  Created by Dhaval Prajapati on 04/01/17.
//  Copyright © 2017 KC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("ViewController")
        let dataTable = Datatable()
        dataTable.frame = CGRect(x: 20, y: 20, width: self.view.frame.width-40, height: self.view.frame.height-40)
        dataTable.fontData = UIFont.systemFont(ofSize: 14)
        dataTable.fontHeader = UIFont.systemFont(ofSize: 16)
        dataTable.setHeaders(list: ["Headers1", "Headers2", "Headers3"], search: [1], filter: [0, 2])
        dataTable.setData(list: [["Headers1":"r1 c1", "Headers2":"r1 c2", "Headers3":"r1 c3"], ["Headers1":"r2 c1", "Headers2":"r2 c2", "Headers3":"r3 c3"], ["Headers1":"r2 c1", "Headers2":"r2 c2", "Headers3":"r3 c3"], ["Headers1":"r2 c1", "Headers2":"r2 c2", "Headers3":"r3 c3"], ["Headers1":"r2 c1", "Headers2":"r2 c2", "Headers3":"r3 c3"], ["Headers1":"r2 c1", "Headers2":"r22 c2", "Headers3":"r3 c33"], ["Headers1":"r2 c1", "Headers2":"r23 c2", "Headers3":"r3 c3"], ["Headers1":"rf2 c1", "Headers2":"r2 c2", "Headers3":"r3 c3"]])
        dataTable.plotData()
        self.view.addSubview(dataTable)
        
//        let dataTable = Datatable()
//        dataTable.frame = self.view.frame
//        self.view.addSubview(dataTable)
//        dataTable.datasource = [["Data 11", "Data 12", "Data 13"], ["Data 21", "Data 22", "Data 23"]]
//        var data = [DataModel]()
//        for i in 1...3 {
//            let temp = DataModel()
//            temp.title = "Header \(i)"
//            data.append(temp)
//        }
//        dataTable.headers = data
//        dataTable.performAction()
    }
}

