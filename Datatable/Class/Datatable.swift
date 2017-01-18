//
//  Datatable.swift
//  Datatable
//
//  Created by Dhaval Prajapati on 04/01/17.
//  Copyright © 2017 KC. All rights reserved.
//

import UIKit
import Foundation

// WHICH CRITERIA WILL APPLY FOR PERTICULAR COLUMN
enum ColumnType {
    case none
    case search
    case filter
}
// ENUM DECLARATION FOR SORTING HEADER IN ASC OR DESC
enum HeaderSort {
    case none
    case asc
    case desc
}

class Datatable: UIView, UITableViewDelegate, UITableViewDataSource, SearchPopoverDelegate {
    // MARK: - DECLARATIONS
    // VIEWS
    private var scrollMain: UIScrollView! = UIScrollView()
    private var lblNoData: UILabel?
    private var viewHeader: UIView?
    private var tblMain: UITableView! = UITableView()
    
    // COMMON CONFIGURATIONS
    public var fontData: UIFont! =  UIFont.systemFont(ofSize: 14)
    public var fontHeader: UIFont! =  UIFont.systemFont(ofSize: 14)
    
    public var cw: CGFloat = 100.0
    public var ch: CGFloat = 40.0
    public var mh: CGFloat = 0
    
    private var th: CGFloat?
    
    public var headerBackgroundColor: UIColor = UIColor(red: 249/255.0, green: 250/255.0, blue: 251/255.0, alpha: 1.0)
    public var headerTitleColor: UIColor = UIColor(red: 55/255.0, green: 58/255.0, blue: 60/255.0, alpha: 1.0)
    public var headerBorderColor: UIColor = UIColor(red: 34/255.0, green: 36/255.0, blue: 38/255.0, alpha: 0.1)
    
    public var headerContentHorizontalAlignment: UIControlContentHorizontalAlignment = .left
    public var headerTitleEdgeInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
    
    private var error = [String]()
    
    // DATA
    private var headers: [DataModel]?
    private var datasource: [[String:String]] = [[String:String]]()
    private var fd: [[String:String]] = [[String:String]]()
    
    private var ss: [[String: [String]]]?
    
    // MARK: - IMPLEMENTATIONS
    // OVERRIDE INITIAL VALUE
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC METHODS
    // PREPARE DATA
    func setHeaders(list: [String]?, width: [Int: CGFloat]? = nil, search: [Int]? = nil, filter: [Int]? = nil) {
        if list != nil {
            if list!.count > 0 {
                if (search != nil && filter != nil) {
                    let s = Set(search!)
                    let f = Set(filter!)
                    let r = s.intersection(f)
                    if r.count > 0 {
                        error.append("Can not apply search and filter to single column\n<at Index: \(r.sorted())>")
                        return
                    }
                }
                headers = [DataModel]()
                for (i, h) in (list?.enumerated())! {
                    let m = DataModel()
                    m.title = h
                    
                    m.type = ColumnType.none
                    
                    if search != nil {
                        if (search?.contains(i))! {
                            m.type = ColumnType.search
                        }
                    }
                    
                    if filter != nil {
                        if (filter?.contains(i))! {
                            m.type = ColumnType.filter
                        }
                    }
                    
                    m.width = self.calculateWidth(i: i, t: list!.count, width: width)
                    m.height = ch
                    headers!.append(m)
                }
                print("headers: \(headers)")
            }
        }
    }
    
    func setData(list: [[String : String]]) {
        self.datasource = list
    }
    
    // PLOT DATA
    public func plotData() {
        self.drawScrollView()
        self.fd = self.datasource
        // DATA RELIABILITY CHECK
        if error.count == 0 {
            if self.datasource.count == 0 {
                lblNoData?.isHidden = false
                self.drawNoDataLabel()
            } else {
                self.drawHeaders()
                self.drawTableView()
            }
        } else {
            lblNoData?.isHidden = false
            self.drawNoDataLabel(t: error.joined(separator: "\n"))
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    // HELPER CLASSES
    private func calculateWidth(i: Int, t: Int, width: [Int: CGFloat]?) -> CGFloat {
        if width != nil {
            return cw
        } else {
            let x: CGFloat = CGFloat(self.frame.size.width/CGFloat(t))
            if x < cw {
                return cw
            }
            return x + (CGFloat(t-1)/CGFloat(t))
        }
    }
    
    // DATA IMPLEMENTATION
    
    // PREPARE SCROLL VIEW (scrollMain)
    private func drawScrollView() {
        let cn1: NSLayoutConstraint! = NSLayoutConstraint(item: self.scrollMain, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        let cn2: NSLayoutConstraint! = NSLayoutConstraint(item: self.scrollMain, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let cn3: NSLayoutConstraint! = NSLayoutConstraint(item: self.scrollMain, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0)
        let cn4: NSLayoutConstraint! = NSLayoutConstraint(item: self.scrollMain, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0)
        
        self.scrollMain.scrollToTop()
        
        self.addSubview(self.scrollMain)
        self.scrollMain.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([cn1, cn2, cn3, cn4])
    }
    
    // NO DATA LABEL (lblNoData)
    private func drawNoDataLabel(t: String = "No Data") {
        self.lblNoData = UILabel()
        lblNoData?.numberOfLines = 0
        lblNoData?.text = t
        
        let cn1: NSLayoutConstraint! = NSLayoutConstraint(item: self.lblNoData!, attribute: .leading, relatedBy: .equal, toItem: self.scrollMain, attribute: .leading, multiplier: 1.0, constant: 10)
        let cn2: NSLayoutConstraint! = NSLayoutConstraint(item: self.lblNoData!, attribute: .top, relatedBy: .equal, toItem: self.scrollMain, attribute: .top, multiplier: 1.0, constant: 10)
        let cn3: NSLayoutConstraint! = NSLayoutConstraint(item: self.lblNoData!, attribute: .height, relatedBy: .equal, toItem: self.scrollMain, attribute: .height, multiplier: 1.0, constant: -20)
        let cn4: NSLayoutConstraint! = NSLayoutConstraint(item: self.lblNoData!, attribute: .width, relatedBy: .equal, toItem: self.scrollMain, attribute: .width, multiplier: 1.0, constant: -20)
        
        self.scrollMain.addSubview(self.lblNoData!)
        self.lblNoData!.translatesAutoresizingMaskIntoConstraints = false
        self.scrollMain.addConstraints([cn1, cn2, cn3, cn4])
        
        // SET PROPERTIES
        lblNoData?.textAlignment = .center
        lblNoData?.font = fontData
    }
    
    // DRAW HEADERS
    private func drawHeaders() {
        
        if self.viewHeader == nil {
            viewHeader = UIView()
        }
        var w:CGFloat = 1
        var h: CGFloat = 0
        
        for (i, j) in headers!.enumerated() {
            let btn: UIButton! = UIButton(type: .custom)
            
            let cn1: NSLayoutConstraint! = NSLayoutConstraint(item: btn, attribute: .leading, relatedBy: .equal, toItem: self.viewHeader, attribute: .leading, multiplier: 1.0, constant: (w-1))
            let cn2: NSLayoutConstraint! = NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: self.viewHeader, attribute: .top, multiplier: 1.0, constant: 0)
            let cn3: NSLayoutConstraint! = NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: j.height!)
            let cn4: NSLayoutConstraint! = NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: j.width)
            
            btn.setTitle(j.title, for: .normal)
            btn.setTitleColor(self.headerTitleColor, for: .normal)
            btn.backgroundColor = self.headerBackgroundColor
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Datatable.btnHeaderTapped(g:)))
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(Datatable.btnHeaderLongPressed(g:)))
            btn.addGestureRecognizer(tapGesture)
            btn.addGestureRecognizer(longGesture)
            
            // APPLYING BORDERS
            if i != 0 {
                let l = CGRect(x: 0, y: 0, width: 1, height: j.height!)
                btn.layer.singleBorder(color: self.headerBorderColor, frame: l)
            }
            
            let b = CGRect(x: 0, y: j.height!-1, width: j.width, height: 1)
            btn.layer.singleBorder(color: self.headerBorderColor, frame: b)
            
            btn.tag = i
            btn.titleLabel?.font = self.fontHeader
            btn.contentHorizontalAlignment = self.headerContentHorizontalAlignment
            btn.titleEdgeInsets = self.headerTitleEdgeInsets
            
            self.viewHeader?.addSubview(btn)
            btn.translatesAutoresizingMaskIntoConstraints = false
            self.viewHeader?.addConstraints([cn1, cn2, cn3, cn4])
            w += j.width - 1
            if j.height! > h {
                h = j.height!
            }
        }
        
        let cn1: NSLayoutConstraint! = NSLayoutConstraint(item: self.viewHeader!, attribute: .leading, relatedBy: .equal, toItem: self.scrollMain, attribute: .leading, multiplier: 1.0, constant: 0)
        let cn2: NSLayoutConstraint! = NSLayoutConstraint(item: self.viewHeader!, attribute: .top, relatedBy: .equal, toItem: self.scrollMain, attribute: .top, multiplier: 1.0, constant: 0)
        let cn3: NSLayoutConstraint! = NSLayoutConstraint(item: self.viewHeader!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: h)
        let cn4: NSLayoutConstraint! = NSLayoutConstraint(item: self.viewHeader!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: w)
        
        self.viewHeader!.translatesAutoresizingMaskIntoConstraints = false
        self.scrollMain?.addConstraints([cn1, cn2, cn3, cn4])
        self.scrollMain.contentSize = CGSize(width: w, height: self.scrollMain.contentSize.height)
        self.th = self.frame.size.height - h
        
        self.mh = h
        
        if !(self.viewHeader?.isDescendant(of: self.scrollMain))! {
            self.scrollMain.addSubview(self.viewHeader!)
        }
    }
    
    // DRAW CONTENTS
    private func drawTableView() {
        let cn1: NSLayoutConstraint! = NSLayoutConstraint(item: self.tblMain, attribute: .leading, relatedBy: .equal, toItem: self.scrollMain, attribute: .leading, multiplier: 1.0, constant: 0)
        let cn2: NSLayoutConstraint! = NSLayoutConstraint(item: self.tblMain, attribute: .top, relatedBy: .equal, toItem: self.viewHeader, attribute: .bottom, multiplier: 1.0, constant: 0)
        let cn3: NSLayoutConstraint! = NSLayoutConstraint(item: self.tblMain, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.th!)
        let cn4: NSLayoutConstraint! = NSLayoutConstraint(item: self.tblMain, attribute: .width, relatedBy: .equal, toItem: self.viewHeader, attribute: .width, multiplier: 1.0, constant: 0)
        
        self.tblMain.backgroundColor = UIColor.clear
        self.tblMain.tableFooterView = UIView()
        
        self.tblMain.separatorInset = UIEdgeInsets.zero
        self.tblMain.cellLayoutMarginsFollowReadableWidth = false
        self.tblMain.separatorColor = self.headerBorderColor
        self.tblMain.separatorStyle = .singleLine
        
        self.tblMain.delegate = self
        self.tblMain.dataSource = self
        
        self.tblMain.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.scrollMain.addSubview(self.tblMain)
        self.tblMain.translatesAutoresizingMaskIntoConstraints = false
        self.scrollMain.addConstraints([cn1, cn2, cn3, cn4])
    }
    
    // MARK: - ACTION HANDLING
    
    @IBAction func btnHeaderTapped(g: UIGestureRecognizer) {
        print("Tap")
        // CHECK IF ALREADY SORTED
        let s = (g.view as! UIButton)
        if (self.headers?.count)! > s.tag {
            if let r = headers?[s.tag].sort {
                if r == .none {
                    self.sortASC(b: s)
                } else if r == .asc {
                    self.sortDESC(b: s)
                } else if r == .desc {
                    self.sortASC(b: s)
                }
            }
        }
    }
    
    @IBAction func btnHeaderLongPressed(g: UIGestureRecognizer) {
        if g.state == .began {
            let t = (g.view as! UIButton).tag
            if (self.headers?.count)! > t {
                if let y = headers?[t].type {
                    if y == .search {
                        print("Search")
                        self.drawSearchPopOver(s: (g.view as! UIButton))
                    } else if y == .filter {
                        print("Filter")
                        self.drawFilterPopOver(s: (g.view as! UIButton))
                    } else {
                        print("NO Filter Applied")
                    }
                }
            }
        }
    }
    
    func didCloseSearchPopup(txt: String?, id: Int) {
        if self.ss == nil {
            self.ss = [[String: [String]]]()
        }
        if txt != "" {
            var temp = [String: [String]]()
            let t = headers![id].title!
            for (i, h) in (self.ss?.enumerated())! {
                if h[t] != nil {
                    if (h[t]?.count)! > 0 {
                        self.ss?[i][t] = [txt!]
                        self.applyAllFilters()
                        return
                    }
                }
            }
            temp[t] = [txt!]
            self.ss?.append(temp)
        } else {
            let t = headers![id].title!
            for (i, h) in (self.ss?.enumerated())! {
                if h[t] != nil {
                    if (h[t]?.count)! > 0 {
                        self.ss?.remove(at: i)
                    }
                }
            }
        }
        self.applyAllFilters()
    }
    
    func applyAllFilters() {
        if (self.ss?.count)! > 0 {
            for (i, h) in (self.ss?.enumerated())! {
                let t = headers?.filter({ item -> Bool in
                    return item.title == h.keys.first!
                })
                print(t!.first!.type!)
                if t!.first!.type! == .search {
                    let sp = NSPredicate(format: "\(h.keys.first!) CONTAINS[C] %@", h.values.first!.first!)
                    var a = [[String: String]]()
                    if i == 0 {
                        a = (self.datasource as NSArray).filtered(using: sp) as! [[String : String]]
                    } else {
                        a = (self.fd as NSArray).filtered(using: sp) as! [[String : String]]
                    }
                    self.fd = a
                }
            }
        } else {
            self.fd = self.datasource
        }
        self.tblMain.reloadData()
    }
    
    // SORTING
    func sortASC(b: UIButton) {
        // START SORTING
        self.resetHeaderSorting()
        self.headers?[b.tag].sort = .asc
        self.fd = self.fd.sorted (by: { (r1, r2) -> Bool in
            return r1[b.titleLabel!.text!]?.localizedStandardCompare(r2[b.titleLabel!.text!]!) == .orderedAscending
        })
        self.tblMain.reloadData()
    }
    
    func sortDESC(b: UIButton) {
        // START SORTING
        self.resetHeaderSorting()
        self.headers?[b.tag].sort = .desc
        self.fd = self.fd.sorted (by: { (r1, r2) -> Bool in
            return r1[b.titleLabel!.text!]?.localizedStandardCompare(r2[b.titleLabel!.text!]!) == .orderedDescending
        })
        self.tblMain.reloadData()
    }
    
    func resetHeaderSorting(){
        for (_, h) in (headers?.enumerated())! {
            h.sort = .none
        }
    }
    
    // SEARCH POPOVER
    func drawSearchPopOver(s: UIButton) {
        let c = self.getCurrentViewController()
        let t = headers![s.tag].title!
        var data: String? = nil
        if self.ss != nil {
            for (_, h) in (self.ss?.enumerated())! {
                if h[t] != nil {
                    if (h[t]?.count)! > 0 {
                        data = h[t]!.first
                    }
                }
            }
        }
        let s = Utility.getSearchPopover(vc: c!, sv: s, ad: .up, sr: nil, dv: self, data: data)
        c?.present(s, animated: true, completion: nil)
    }
    
    // FILTER POPOVER
    func drawFilterPopOver(s: UIButton) {
        let c = self.getCurrentViewController()
        let t = headers![s.tag].title!
        var sel: [String]? = nil
        if self.ss != nil {
            for (_, h) in (self.ss?.enumerated())! {
                if h[t] != nil {
                    if (h[t]?.count)! > 0 {
                        sel = h[t]!
                    }
                }
            }
        }

        var all: [String]? = nil
        let tmp = (self.datasource as NSArray).value(forKeyPath: "\(t)")
        let set = NSSet(array: tmp as! [String])
        all = set.allObjects as [Any]? as! [String]?

//        let tmp = (self.datasource as NSDictionary).allValues
//        if tmp != nil {
//            let s = NSSet(array)
//        }
//        let s = NSSet(array: ((self.datasource as NSArray).value(forKey: t) as! [String]?))
//        let a = s.
        
//        let a = (self.datasource as NSArray).value(forKey: t) as! [String]
//            .filter {
//            seenType.updateValue(false, forKey: $0["type"] as Int) ?? true
//        }

        let s = Utility.getFilterPopover(vc: c!, sv: s, ad: .up, sr: nil, dv: self, all: all, sel: sel)
        c?.present(s, animated: true, completion: nil)
    }
    
    // MARK: - TABLEVIEW DELEGATE AND DATASOURCE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fd.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.mh
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    //
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.selectionStyle = .none
        var w:CGFloat = 1
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        for (i, h) in (self.headers?.enumerated())! {
            let lbl = UILabel()
            lbl.font = self.fontData
            lbl.numberOfLines = 0
            
            // APPLYING BORDERS
            if i != 0 {
                let f = CGRect(x: -self.headerTitleEdgeInsets.left, y: 0, width: 1, height: self.mh)
                lbl.layer.singleBorder(color: self.headerBorderColor, frame: f)
            }
            if self.fd[indexPath.row].count > i {
                lbl.text = (self.fd[indexPath.row][h.title])!
            } else {
                lbl.text = "-"
            }
            lbl.frame = CGRect(x: w-1 + self.headerTitleEdgeInsets.left, y: 0, width: h.width - self.headerTitleEdgeInsets.left, height: h.height!)
            cell.contentView.addSubview(lbl)
            w += h.width - 1
        }
        return cell
    }
}
