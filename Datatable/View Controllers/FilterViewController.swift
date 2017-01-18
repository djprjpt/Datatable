//
//  FilterViewController.swift
//  Datatable
//
//  Created by Dhaval Prajapati on 16/01/17.
//  Copyright © 2017 KC. All rights reserved.
//

import UIKit

protocol FilterPopoverDelegate {
    func didCloseFilterPopup(txt: [String]?)
}

class FilterViewController: UIViewController {
    
    var all: [String]?
    var sel: [String]?
    
    var delegate:FilterPopoverDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Filter View Controller: \(self.all)")
        print("Filter View Controller: \(self.sel)")
    }
}
