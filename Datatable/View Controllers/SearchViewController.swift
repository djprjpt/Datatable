//
//  SearchViewController.swift
//  Datatable
//
//  Created by Dhaval Prajapati on 16/01/17.
//  Copyright © 2017 KC. All rights reserved.
//

import UIKit

protocol SearchPopoverDelegate {
    func didCloseSearchPopup(txt: String?, id: Int)
}

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var txt: UITextField!
    @IBOutlet var btn: UIButton!
    @IBOutlet var clr: UIButton!
    
    var id: Int = -1
    var str: String?
    
    var delegate:SearchPopoverDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txt.delegate = self
        
        btn.layer.cornerRadius = 3.0
        txt.layer.cornerRadius = 3.0
        clr.layer.cornerRadius = 3.0
        
        txt.font = UIFont.systemFont(ofSize: 14)
        let v  = UIView()
        v.frame = CGRect(x:0, y:0, width:5, height:txt.frame.size.height)
        
        txt.placeholder = "Search"
        
        txt.leftView = v
        txt.textColor = UIColor.black.withAlphaComponent(0.6)
        txt.leftViewMode = .always
        txt.autocorrectionType = .no
        txt.autocapitalizationType = .none
        if str == nil {
            txt.clearButtonMode = .whileEditing
            self.isEnable(s: false, b: clr)
            self.isEnable(s: false, b: btn)
        } else {
            txt.text = str!
            txt.clearButtonMode = .always
        }
    }
    
    func isEnable(s: Bool, b: UIButton) {
        if s == false {
            b.backgroundColor = clr.backgroundColor?.withAlphaComponent(0.6)
        } else {
            b.backgroundColor = clr.backgroundColor?.withAlphaComponent(1.0)
        }
        b.isEnabled = s
    }
    
    @IBAction func dismissPopover(sender: UIButton) {
        delegate?.didCloseSearchPopup(txt: txt.text, id: id)
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearSearch(sender: UIButton) {
        self.txt.text = ""
        delegate?.didCloseSearchPopup(txt: txt.text, id: id)
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isEnable(s: true, b: clr)
        self.isEnable(s: true, b: btn)
    }
}
