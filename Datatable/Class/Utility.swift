//
//  Utility.swift
//  Datatable
//
//  Created by Dhaval Prajapati on 16/01/17.
//  Copyright © 2017 KC. All rights reserved.
//

import UIKit

class Utility: NSObject {

    static func getSearchPopover(vc:UIViewController, sv:UIView, ad:UIPopoverArrowDirection, sr:CGRect?, dv: UIView, data: String?) -> SearchViewController {
        let sp = SearchViewController(nibName: "SearchViewController", bundle: nil)
        sp.modalPresentationStyle = UIModalPresentationStyle.popover
        sp.preferredContentSize =  CGSize(width: 320, height: 60)
        sp.delegate = dv as? SearchPopoverDelegate
        sp.id = sv.tag
        sp.str = data
        
        let spc = sp.popoverPresentationController!
        spc.permittedArrowDirections = ad
        spc.sourceView = sv
        spc.backgroundColor = UIColor(red: 175/255.0, green: 189/255.0, blue: 33/255.0, alpha: 1.0)
        spc.sourceRect = sr ?? sv.bounds
        spc.delegate = vc as? UIPopoverPresentationControllerDelegate
        return sp
    }

    static func getFilterPopover(vc:UIViewController, sv:UIView, ad:UIPopoverArrowDirection, sr:CGRect?, dv: UIView, all: [String]?, sel: [String]?) -> FilterViewController {
        let fp = FilterViewController(nibName: "FilterViewController", bundle: nil)
        fp.modalPresentationStyle = UIModalPresentationStyle.popover
        fp.preferredContentSize =  CGSize(width: 320, height: 150)
        fp.delegate = dv as? FilterPopoverDelegate
        fp.all = all
        fp.sel = sel
        
        let fpc = fp.popoverPresentationController!
        fpc.permittedArrowDirections = ad
        fpc.sourceView = sv
        fpc.backgroundColor = UIColor(red: 175/255.0, green: 189/255.0, blue: 33/255.0, alpha: 1.0)
        fpc.sourceRect = sr ?? sv.bounds
        fpc.delegate = vc as? UIPopoverPresentationControllerDelegate
        return fp
    }

}
